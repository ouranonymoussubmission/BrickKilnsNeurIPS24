name=delhi  # lucknow, wb (stands for west bengal)
task=aa # two options: obb, aa (axis-aligned)
yolo_task=detect # two options: obb, detect (detect mode is for axis-aligned)
suffix=v1  # custom suffix. Not too important.
model=yolov8x-worldv2 # yolov8x-worldv2, yolov8l-obb, ...  # specify the model here
epochs=100
data_folder=$name\_$task\_$suffix
data_path=/home/username/kilns_neurips24/crossval/$data_folder
experimentName=$data_folder\_model_$model\_epochs_$epochs

echo "Name: $name"
echo "Task: $task"
echo "Suffix: $suffix"
echo "Epochs: $epochs"
echo "Data Folder: $data_folder"
echo "Data Path: $data_path"
echo "Experiment Name: $experimentName"

# Specify fold and device here. This runs in background.
fold=3
device=0
nohup yolo $yolo_task train model=$model.pt data=$data_path/$fold/data.yml device=$device imgsz=1120 epochs=$epochs val=False cache=True name=$experimentName\_$fold save=True save_conf=True save_txt=True > $experimentName\_$fold.log 2>&1 &
echo "Fold $fold fired on GPU $device!"
