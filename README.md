# fmaskilicious

Orchestrate [FMask 4.5  cloud masking](https://github.com/GERSL/Fmask) 🍭

## Installation

1. Download FMask 4.5 standalone Linux installer in this [Google Drive](https://drive.google.com/drive/folders/1isoMVCrYo1YTc6bLglbmpJKjMCJl33cg)
   and copy it into the root of this repository.

2. Run

   ```bash
   $ docker build -t fmask .
   ```

   from the root of this repository.

## Usage

To process a Sentinel 2 scene (e.g. `S2A_MSIL1C_20180624T103021_N0206_R108_T33UUB_20180624T160117`)
that is located on your PC run

```bash
$ docker run \
    -v /path/to/safe:/mnt/input-dir:ro \
    -v /path/to/output:/mnt/output-dir:rw \
    -it fmask \
    S2A_MSIL1C_20180624T103021_N0206_R108_T33UUB_20180624T160117 *T33UUB* \
    [cloud_buffer_distance] [shadow_buffer_distance] \
    [snow_buffer_distance] [cloud_prob_threshold]
```

Note that the folder mounted at `/mnt/input-dir` needs to contain the SAFE folder with the given
scene ID (in this case `S2A_MSIL1C_20180624T103021_N0206_R108_T33UUB_20180624T160117.SAFE`).
The second argument is a glob pattern matching the granules to be processed (`*` to process all granules).

The argument with `[]` are configures of Fmask, which are optional. The default values are 3, 3, 0, 22.5 respectively.

Results are written to the folder mounted on `/mnt/output-dir` (one per granule).

e.g.
```bash
$ docker run \
-v /home/chiron/Documents/20230618/39RVM/RAW:/mnt/input-dir:ro \
-v /home/chiron/Documents/20230618/39RVM/FMASK:/mnt/output-dir:rw \
-it fmask \
S2A_MSIL1C_20210512T071621_N0300_R006_T39RVM_20210512T094649 *T39RVM* 3 3 0 22.5
```

