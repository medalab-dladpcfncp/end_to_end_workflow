# Segmentation Training, Evaluation & Inference

## Environment Setup

Prerequired packages:
 - PyTorch
 - MONAI
 - PyTorch Lightning
 - Tensorboard

Install envrionment:

`pip install git+https://gitlab.com/nanaha1003/manafaln.git`

## Data Preparation

All data should be converted into Nifti (`.nii` or `.nii.gz`) format and collected in one directory `data_root`.
It also requires a JSON file that describes the dataset and training, validation, testing splits, the filenames
in the JSON file are *relative path* to the `data_root` directory.

An example `datalist.json`
```
{
  "training": [
    {
      "image": "IM_NTUH_001.nii.gz",
      "label": "LB_NTUH_001.nii.gz"
    },
    {
      "image": "IM_NTUH_002.nii.gz",
      "label": "LB_NTUH_002.nii.gz"
    }
  ],

  "validation": [
    {
      "image": "IM_NTUH_003.nii.gz",
      "label": "LB_NTUH_003.nii.gz"
    }
  ],

  "testing": [
    {
      "image": "IM_NTUH_004.nii.gz",
      "label": "LB_NTUH_004.nii.gz"
    }
  ]
}
```

Once the data is ready, you will need to modify `config/config_train.json` and `config/config_test.json` and
replace the `data_root` and `data_list` settings to the correct one.

## Model Training

Run the training script directly:

```
./command/train.sh
```

or execute the Python module:

```
python -m manafaln.apps.train -c config/config_train.json
```

You might need to customize the `config/config_train.json` for your hardware, the default settings are
tested on NVIDIA DGX-Station V100 32G with 256GB RAM and 4 V100 GPUs.

## Evaluation

The evaluation workflow is also defined in `config/config_test.json`, by default the evaluation workflow
will compute the average Dice score of both pancreas and tumor on the `testing` split. In this case the
`label` key must exist in the `data_list` JSON file.

Run evaluation:
```
python -m manafaln.apps.validate \
    -c config/config_test.json \
    --ckpt lightning_logs/version_0/checkpoints/best_model.ckpt
```

The command argument `ckpt` will depends on which checkpoint file you want to evaluate.

## Inference

The infernece workflow is also defined in `config/config_test.json`, by default it will run through all data in training,
validation and testing splits and save the segmentation to `results` directory in `.nii.gz` format. This behavior can be
changed by setting the `data_list_key` of the `test` section in `config/config_test.json`.

Command:
```
python -m manafaln.apps.inference \
    -c config/config_test.json \
    --ckpt lightning_logs/version_0/checkpoints/best_model.ckpt
```

