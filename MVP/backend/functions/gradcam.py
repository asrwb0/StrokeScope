# type: ignore
import torch
import torch.nn.functional as F
import numpy as np
import cv2, uuid, os

HEATMAP_DIR = os.path.join(os.getcwd(), "heatmaps")
GRADCAM_LAYER = "backbone.blocks.6"

def generate_heatmap(model, preprocessed_tensor, original_image, label_index=None):
    model.eval()
    activations, gradients = {}, {}

    target = dict(model.named_modules())[GRADCAM_LAYER]
    target.register_forward_hook(lambda m, i, o: activations.update({'out': o}))
    target.register_full_backward_hook(lambda m, gi, go: gradients.update({'out': go[0]}))

    output = model(preprocessed_tensor)
    probs = torch.sigmoid(output)
    if label_index is None:
        label_index = int(probs[0].argmax())

    model.zero_grad()
    probs[0, label_index].backward()

    grads = gradients['out'].mean(dim = (2, 3), keepdim = True)
    cam = (activations['out'] * grads).sum(dim = 1).squeeze()
    cam = F.relu(cam).cpu().numpy()
    cam = (cam - cam.min()) / (cam.max() - cam.min() + 1e-8)

    heatmap = cv2.resize(cam, (224, 224))
    heatmap_colored = cv2.applyColorMap(np.uint8(255 * heatmap), cv2.COLORMAP_JET)

    original_bgr = cv2.resize(cv2.cvtColor(original_image, cv2.COLOR_RGB2BGR), (224, 224))
    blended = cv2.addWeighted(heatmap_colored, 0.4, original_bgr, 0.6, 0)
    cv2.putText(blended, f"Class: {label_index}", (10, 25),
                cv2.FONT_HERSHEY_SIMPLEX, 0.8, (255, 255, 255), 2)

    os.makedirs(HEATMAP_DIR, exist_ok = True)
    path = os.path.join(HEATMAP_DIR, f"{uuid.uuid4()}.jpg")
    cv2.imwrite(path, blended)
    return path