"Checking if git is installed...";
try
{
	Get-Command -ErrorAction Stop git | Out-Null;
}
catch [System.Management.Automation.CommandNotFoundException]
{
	"Git must be installed and accessible by Powershell.";
	Exit;
}
"git was found."

$originalWorkingDir = Get-Location;
$outDirName = "Antlr4CppRuntime";
$outDir = Join-Path -Path $originalWorkingDir -ChildPath $outDirName;

if (Test-Path $outDir)
{
	"Deleting old contents in output directory: $($outdir)";
	Get-Childitem "$($outDir)/*" | Remove-Item -Recurse;
}
else
{
	"Creating output directory: $($outDir)";
	mkdir $outDir;
}


$tempDir = [System.IO.Path]::GetTempPath();
$workingDirName = "clone_antlr4_cpp_runtime$((New-Guid).ToString())";
$workingDir = Join-Path -Path $tempDir -ChildPath $workingDirName;

"Cloning repository";
mkdir $workingDir;
cd $workingDir;
git clone --no-checkout --branch master https://github.com/antlr/antlr4;
cd antlr4;
git sparse-checkout set runtime/Cpp/runtime;
git checkout HEAD;
"Copying cloned contents to output directory";
Copy-Item -Path ".gitignore" -Destination $outDir;
Copy-Item -Path "LICENSE.txt" -Destination $outDir;
Copy-Item -Path "runtime/Cpp/runtime/*" -Destination $outDir -Recurse;
cd $originalWorkingDir;
Remove-Item $workingDir -Recurse -Force;