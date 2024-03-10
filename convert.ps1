<#
PowerShell script to convert Jupiter notebooks to PDF

Input : full path to the notebook
#>

param (
    [string]$notebook
)

function New-TemporaryDirectory {
    $parent = [System.IO.Path]::GetTempPath()
    [string] $name = [System.Guid]::NewGuid()
    $t = New-Item -ItemType Directory -Path (Join-Path $parent $name)
    $t.FullName
}

# get the notebook name
$name = [System.IO.Path]::GetFileNameWithoutExtension($notebook)
# get the notebook folder
$folder = [System.IO.Path]::GetDirectoryName($notebook)
# get the notebook file name with extension
$notebook_file = [System.IO.Path]::GetFileName($notebook)


# Create temp folder
$temp_folder = New-TemporaryDirectory
$temp_folder_converted =  "$temp_folder"  -Replace "\\", "/"
write-output "temp_folder: ${temp_folder}"
write-output "temp_folder_converted: ${temp_folder_converted}"
# copy the notebook to the temp folder
Copy-Item -Path "$notebook" -Destination "$temp_folder" -Force

# convert temp folder path to wsl path from windows path
# take care of the slashes
$wsl_temp_folder = wsl wslpath -u "$temp_folder_converted"

$docker_image="sergeyhein/sandbox:jupyter_notebook_converter-0.1"
# run the docker container using wsl
write-output "Running the docker container using wsl"
write-output "wsl_temp_folder: ${wsl_temp_folder}"
write-output "docker_image: ${docker_image}"
write-output "notebook: ${notebook}"

wsl --exec docker run --rm -it -v "${wsl_temp_folder}:/data" "${docker_image}" bash