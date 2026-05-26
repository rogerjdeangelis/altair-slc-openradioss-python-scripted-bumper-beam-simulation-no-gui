%let pgm=altair-slc-openradioss-python-scripted-bumper-beam-simulation-no-gui;

%stop_submission;

Altair slc openradioss python scripted bumper beam simulation no gui;

A complete self-contained reproducible example is presented that is entirely scripted, no
GUI or mouse surfing requeried. The entire simulation is done with open source tools.

SOURCE
https://openradioss.atlassian.net/wiki/spaces/OPENRADIOSS/pages/11075585/Bumper+Beam

There are only two files you need to run this simulation.
      Cell_Phone_Drop_0000.rad
      Cell_Phone_Drop_0001.rad

Too long to post here see github
https://github.com/rogerjdeangelis/altair-slc-openradioss-python-scripted-bumper-beam-simulation-no-gui

Openradioss simulation
https://drive.google.com/file/d/1E2Rx_RivLjHpV8aYJ1ZloLiic6RUukOF/view?usp=sharing
also downloadable from this repository, bump_animation.mp4

First Frame https://github.com/rogerjdeangelis/altair-slc-openradioss-python-scripted-bumper-beam-simulation-no-gui/blob/main/frame_0001.png
Last Frame  https://github.com/rogerjdeangelis/altair-slc-openradioss-python-scripted-bumper-beam-simulation-no-gui/blob/main/frame_0101.png

Summary Tables (Too large to save in github - see below for descriptions of the tables)

   D:/wpswrkx/simout.csv                   241 KB (in this repo)
   D:/wpswrkx/global_energy.csv              7 KB (in this repo)
   D:/wpswrkx/cell_data.csv          1,524,904 KB (not included also associated large csv files - very rich detailed data))

  CONTENTS

   1 Preparation
   1 Get github inputs
   2 Get animation & time history
   3 Time history table
   4 Csv to history table
   5 Many plots
      Energy_evolution
      Energy_balance
      Time_step_history
      X_momentumevolve
      Y_momentumevolve
   6 Animation to vtk file
   7 Vtk to vkthdf
   8 vkthdf to csv
   9 vkthdf to cell data
  10 Vtk to mp4

 For macros see
  https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories

Related Repos
https://github.com/rogerjdeangelis/altair-slc-openradioss-python-script-for-cell-phone-drop-simulation-no-gui
https://github.com/rogerjdeangelis/utl-altair-slc-enhanced-openradioss-tensile-strength-simulation-python-no-gui-no-mouse-surfing
https://github.com/rogerjdeangelis/utl-altair-slc-python-script-to-run-openradioss-tensile-strength-simulation
https://github.com/rogerjdeangelis/utl-altair-slc-post-processing-radioss-files-using-openradioss
https://github.com/rogerjdeangelis/utl-personal-altair-slc-with-matlab-sympy-and-r-finite-element-cold-plate-heat-transfer

/*
 _                                        _   _
/ |  _ __  _ __ ___ _ __   __ _ _ __ __ _| |_(_) ___  _ __
| | | `_ \| `__/ _ \ `_ \ / _` | `__/ _` | __| |/ _ \| `_ \
| | | |_) | | |  __/ |_) | (_| | | | (_| | |_| | (_) | | | |
|_| | .__/|_|  \___| .__/ \__,_|_|  \__,_|\__|_|\___/|_| |_|
    |_|            |_|
*/

libname workx "d:/wpswrkx";

MOST OF THE INSTALLS ARE ONLY NEEDED FOR THE ANIMATION, YOU MAY NOT NEED STEPS III-V IF
YOU ARE NOT INTERESTED DIN THE ANIMATION. INTEL API IS NEEDED FOR CUSTOMIZATION OF PENRADIOSS
OR PARALLEL PROCESSING?
There are many python tools you can easily add to the script below for graphics and summary tables.


I INSTALL OPENRADIOSS
---------------------

 a  Go to https://github.com/OpenRadioss/OpenRadioss/releases
 b  Download openradioss_win64.zip
 c  Create directory c:/openradioss
 d  From the unzipped file copy all folders, see below, to c:/openradioss
    The result should look like

    c:/openradioss (should look like)

      <DIR>   exec
      <DIR>   extlib
      <DIR>   hm_cfg_files
      <DIR>   licenses
      <DIR>   openradioss_gui


II  INSTALL INTEL OPENAPI TOOLKIT YOU NEED TO INSTALL VERSION 2 FROM THE ARCHIVES
-----------------------------------------------------------------------------

 a  https://www.intel.com/content/www/us/en/developer/articles/tool/oneapi-archive.html
 b  It automaticall installs at C:/Program Files (x86)/Intel/oneapi


III INSTALL VISUAL STUDIO
-------------------------

 a  https://visualstudio.microsoft.com/vs/community/
 b  C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools


IV  INSTALL FFMPEG
------------------

 a  https://www.gyan.dev/ffmpeg/builds/
 b  C:\Program Files\ffmpeg
 c  esential version
 d  unzip and save to c:/program files


V   INSTALL PARAVIEW
--------------------

 a  https://www.paraview.org/download/
 b  It will install at C:\Program Files\ParaView-6.1.0-Windows-Python3.12-msvc2017-AMD64


VI  Download SLC macros and place in your autocall library for instance c:/wpsoto (also in this repo)
-----------------------------------------------------------------------------------------------------
 a  https://github.com/rogerjdeangelis/utl-macros-used-in-many-of-rogerjdeangelis-repositories
 b  utlfkil
 d  slc_pvbegin  /*-- runs a virtual python ---*/
 e  slc_pvend
 f  slc_psbegin  /*--- runs powershell      ---*/
 g  slc_psend



VII YOU NEED TO PUT THIS IN YOUR AUTOEXEC
-----------------------------------------

  a libname workx "d:/wpswrkx";
  b or set in betewen each section below
    (many many sections. I suggest you put it in your autoexec ---*/


/*---
 ____              _          _ _   _           _      _                   _
|___ \   __ _  ___| |_   __ _(_) |_| |__  _   _| |__  (_)_ __  _ __  _   _| |_ ___
  __) | / _` |/ _ \ __| / _` | | __| `_ \| | | | `_ \ | | `_ \| `_ \| | | | __/ __|
 / __/ | (_| |  __/ |_ | (_| | | |_| | | | |_| | |_) || | | | | |_) | |_| | |_\__ \
|_____| \__, |\___|\__| \__, |_|\__|_| |_|\__,_|_.__/ |_|_| |_| .__/ \__,_|\__|___/
        |___/           |___/                                 |_|

You do not need to run this. You can manually  create d:/rad and download the rad files from this repp

What powershell is doing ( you can do the following manually)

  1 deletes d:/rad directory if it exists
  2 recreate empty d:/rad
  3 copy files from github
    Bumper_Beam_AP_meshed_0000.rad
    Bumper_Beam_AP_meshed_0001.rad
---*/

/*--- clear workx data ---*/
libname workx "d:/wpswrkx";  /*--- put in autoexec ---*/

proc datasets lib=workx kill;
run;

libname workx "d:/wpswrkx";  /*--- put in autoexec ---*/

proc datasets lib=workx kill;
run;

%slc_psbegin; /*--- call powershell ---*/
cards4;
# Deletes d:/rad and all subdirectories/files, recreates the folder, then
# downloads the three OpenRadioss input files from your GitHub repository.

$targetDir = "D:\rad"

# 1. Remove the directory and everything inside it (forcefully, recursively)
if (Test-Path $targetDir) {
    Write-Host "Removing existing directory: $targetDir" -ForegroundColor Yellow
    Remove-Item -Path $targetDir -Recurse -Force
}


# 2. Recreate the empty directory
Write-Host "Creating fresh directory: $targetDir" -ForegroundColor Yellow
New-Item -Path $targetDir -ItemType Directory -Force | Out-Null

# 3. Define the source files (GitHub raw URLs) and their destination names
$files = @(
    @{
        Source = "https://raw.githubusercontent.com/rogerjdeangelis/altair-slc-openradioss-python-scripted-bumper-beam-simulation-no-gui/refs/heads/main/Bumper_Beam_AP_meshed_0000.rad"
        Dest   = "D:\rad\Bumper_Beam_AP_meshed_0000.rad"
    },
    @{
        Source = "https://raw.githubusercontent.com/rogerjdeangelis/altair-slc-openradioss-python-scripted-bumper-beam-simulation-no-gui/refs/heads/main/Bumper_Beam_AP_meshed_0001.rad"
        Dest   = "D:\rad\Bumper_Beam_AP_meshed_0001.rad"
    }
)

# 4. Download each file using Invoke-WebRequest
Write-Host "Downloading files to $targetDir ..." -ForegroundColor Yellow
foreach ($file in $files) {
    try {
        Write-Host "  Downloading: $($file.Source)" -ForegroundColor Cyan
        Invoke-WebRequest -Uri $file.Source -OutFile $file.Dest
        Write-Host "    Saved to: $($file.Dest)" -ForegroundColor Green
    }
    catch {
        Write-Host "    ERROR: Failed to download $($file.Source)" -ForegroundColor Red
        Write-Host "    Exception: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# 5. Optional: List the contents of D:\rad to verify
Write-Host "`nContents of $targetDir :" -ForegroundColor Yellow
Get-ChildItem -Path $targetDir | Format-Table Name, Length -AutoSize

Write-Host "`nScript completed." -ForegroundColor Green
;;;;
%slc_psend;


/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/

/**************************************************************************************************************************/
/*  Altair SLC                                                                                                            */
/*  Removing existing directory: D:\rad                                                                                   */
/*  Creating fresh directory: D:\rad                                                                                      */
/*  Successfully extracted: Bumper_Beam_AP_meshed_0000.rad                                                                */
/*  Success! File saved to: D:\rad\Bumper_Beam_AP_meshed_0000.rad                                                         */
/*  Success! File saved to: D:\rad\Bumper_Beam_AP_meshed_0001.rad                                                         */
/*  Done!                                                                                                                 */
/*                                                                                                                        */
/*  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx*/
/*  DIRECTORY OF D:\RAD                                                                                                   */
/*  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx*/
/*                                                                                                                        */
/*    Contents of D:\rad :                                                                                                */
/*    Name                                      Length                                                                    */
/*    ----                                      ------                                                                    */
/*    D:\rad\Bumper_Beam_AP_meshed_0000.rad    1779784                                                                    */
/*    D:\rad\Bumper_Beam_AP_meshed_0001.rad        747                                                                    */
/*                                                                                                                        */
/*    Script completed.                                                                                                   */
/*                                                                                                                        */
/*  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx*/
/*  Cell_Phone_Drop_0001.rad                                                                                              */
/*  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx*/
/*                                                                                                                        */
/* d:/rad/Cell_Phone_Drop_0001.rad                                                                                        */
/*                                                                                                                        */
/* # Copyright (C) 2022 Altair Engineering Inc. ("Holder")                                                                */
/* # Model is licensed by Holder under CC BY-NC 4.0                                                                       */
/* # (https://creativecommons.org/licenses/by-nc/4.0/legalcode).                                                          */
/* /RUN/Bumper_Beam_AP_meshed/0/                                                                                          */
/*                  100                                                                                                   */
/* /VERS/2022                                                                                                             */
/*                                                                                                                        */
/* #-------------------------------------                                                                                 */
/* # ANIMATION OUTPUT (for ParaView)                                                                                      */
/* #-------------------------------------                                                                                 */
/* /ANIM/DT                                                                                                               */
/* 0.000000 1.000000                                                                                                      */
/* /ANIM/SHELL/TENS/STRESS/ALL                                                                                            */
/* /ANIM/SHELL/TENS/STRAIN/ALL                                                                                            */
/* /ANIM/SHELL/VONM                                                                                                       */
/* /ANIM/SHELL/EPSP                                                                                                       */
/*                                                                                                                        */
/* #-------------------------------------                                                                                 */
/* # H3D OUTPUT (commented out - not needed for ParaView)                                                                 */
/* #-------------------------------------                                                                                 */
/* #/H3D/DT                                                                                                               */
/* #0.000000 1.000000                                                                                                     */
/* #/H3D/SHELL/VONM                                                                                                       */
/* #/H3D/SHELL/EPSP                                                                                                       */
/*                                                                                                                        */
/* /DT/NODA/CST/0                                                                                                         */
/* 0.9 0.001                                                                                                              */
/* /PRINT/-100/55                                                                                                         */                                                             */
/* /TFILE/0                                                                                                               */                                                             */
/* 0.100000                                                                                                               */                                                             */
/*                                                                                                                        */
/*  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx*/
/*  Cell_Phone_Drop_0000.rad                                                                                              */
/*  xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx*/
/*                                                                                                                        */
/*  RADIOSS STARTER                                                                                                       */
/*  # Copyright (C) 2022 Altair Engineering Inc. ("Holder")                                                               */
/*  # Model is licensed by Holder under CC BY-NC 4.0                                                                      */
/*  # (https://creativecommons.org/licenses/by-nc/4.0/legalcode).                                                         */
/*  #---1----|----2----|----3----|----4----|----5----|----6----|----7----|----8----|----9----|---10----|                  */
/*  /BEGIN                                                                                                                */
/*  Bumper_Beam_AP_meshed                                                                                                 */
/*        2022         0                                                                                                  */
/*                    kg                  mm                  ms                                                          */
/*                    kg                  mm                  ms                                                          */
/*  #---1----|----2----|----3----|----4----|----5----|----6----|----7----|----8----|----9----|---10----|                  */
/*  #-  1. CONTROL CARDS:                                                                                                 */
/*  #---1----|----2----|----3----|----4----|----5----|----6----|----7----|----8----|----9----|---10----|                  */
/*  /TITLE                                                                                                                */
/*                                                                                                                        */
/*  #---1----|----2----|----3----|----4----|----5----|----6----|----7----|----8----|----9----|---10----|                  */
/*  #-  2. MATERIALS:                                                                                                     */
/*  #---1----|----2----|----3----|----4----|----5----|----6----|----7----|----8----|----9----|---10----|                  */
/*  /MAT/PLAS_JOHNS/1                                                                                                     */
/*  Steel_DP600                                                                                                           */
/*  #              RHO_I                                                                                                  */
/*               7.85E-6                   0                                                                              */
/*  #                  E                  Nu     Iflag                                                                    */
/*                   210                  .3         0                                                                    */
/*  #                  a                   b                   n           EPS_p_max            SIG_max0                  */
/*                    .3                  .3                  .3                   0                   0                  */
/*  #                  c           EPS_DOT_0       ICC   Fsmooth               F_cut               Chard                  */
/*                     0                   0         0         0                   0                   0                  */
/*  #                  m              T_melt              rhoC_p                 T_r                                      */
/*                     0                   0                   0                   0                                      */
/*  /*                                                                                                                    */
/* ...                                                                                                                    */
/* ...                                                                                                                    */
/* /TH/RWALL/4                                                                                                            */
/* TH RWALL                                                                                                               */
/* #     var1      var2      var3      var4      var5      var6      var7      var8      var9     var10                   */
/* DEF                                                                                                                    */
/* #     Obj1      Obj2      Obj3      Obj4      Obj5      Obj6      Obj7      Obj8      Obj9     Obj10                   */
/*          1                                                                                                             */
/* #---1----|----2----|----3----|----4----|----5----|----6----|----7----|----8----|----9----|---10----|                   */
/* /TH/ACCEL/5                                                                                                            */
/* TH ACCEL                                                                                                               */
/* #     var1      var2      var3      var4      var5      var6      var7      var8      var9     var10                   */
/* DEF                                                                                                                    */
/* #     Obj1      Obj2      Obj3      Obj4      Obj5      Obj6      Obj7      Obj8      Obj9     Obj10                   */
/*          1         2                                                                                                   */
/* #---1----|----2----|----3----|----4----|----5----|----6----|----7----|----8----|----9----|---10----|                   */
/* /TH/SECTIO/6                                                                                                           */
/* TH SECTIO                                                                                                              */
/* #     var1      var2      var3      var4      var5      var6      var7      var8      var9     var10                   */
/* DEF                                                                                                                    */
/* #     Obj1      Obj2      Obj3      Obj4      Obj5      Obj6      Obj7      Obj8      Obj9     Obj10                   */
/*          1                                                                                                             */
/* #---1----|----2----|----3----|----4----|----5----|----6----|----7----|----8----|----9----|---10----|                   */
/* /END                                                                                                                   */
/* #---1----|----2----|----3----|----4----|----5----|----6----|----7----|----8----|----9----|---10----|                   */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*                   _     _
(_)_ __  _ __  _   _| |_  | | ___   __ _
| | `_ \| `_ \| | | | __| | |/ _ \ / _` |
| | | | | |_) | |_| | |_  | | (_) | (_| |
|_|_| |_| .__/ \__,_|\__| |_|\___/ \__, |
        |_|                        |___/
*/

Altair SLC
Removing existing directory: D:\rad
Creating fresh directory: D:\rad
Downloading files to D:\rad ...
  Downloading: https://raw.githubusercontent.com/rogerjdeangelis/altair-slc-openradioss-python-scripted-bumper-beam-simulation-no-gui/refs/heads/main/Bumper_Beam_AP_meshed_0000.rad
    Saved to: D:\rad\Bumper_Beam_AP_meshed_0000.rad
  Downloading: https://raw.githubusercontent.com/rogerjdeangelis/altair-slc-openradioss-python-scripted-bumper-beam-simulation-no-gui/refs/heads/main/Bumper_Beam_AP_meshed_0001.rad
    Saved to: D:\rad\Bumper_Beam_AP_meshed_0001.rad

Contents of D:\rad :

Name                            Length
----                            ------
Bumper_Beam_AP_meshed_0000.rad 1779784
Bumper_Beam_AP_meshed_0001.rad     747

Script completed.

/*____             _                _                 _   _               ___    _   _                                _
|___ /   __ _  ___| |_   __ _ _ __ (_)_ __ ___   __ _| |_(_) ___  _ __   ( _ )  | |_(_)_ __ ___   ___   ___  ___ _ __(_) ___  ___
  |_ \  / _` |/ _ \ __| / _` | `_ \| | `_ ` _ \ / _` | __| |/ _ \| `_ \  / _ \/\| __| | `_ ` _ \ / _ \ / __|/ _ \ `__| |/ _ \/ __|
 ___) || (_| |  __/ |_ | (_| | | | | | | | | | | (_| | |_| | (_) | | | || (_>  <| |_| | | | | | |  __/ \__ \  __/ |  | |  __/\__ \
|____/  \__, |\___|\__| \__,_|_| |_|_|_| |_| |_|\__,_|\__|_|\___/|_| |_| \___/\/ \__|_|_| |_| |_|\___| |___/\___|_|  |_|\___||___/
        |___/
*/

/*--- CREATE SIEMEN ANIMATION AND TIME HISTORY CSV FILE  ---*/

options validvarname=v7;
options set=PYTHONHOME "D:\py314";
proc python;
submit;
import os
import pandas as pd
import subprocess
from pathlib import Path

# ============================================================================
# CONFIGURATION
# ============================================================================

OPENRADIOSS_PATH = Path("C:/openradioss")
STARTER_EXE = OPENRADIOSS_PATH / "exec" / "starter_win64.exe"
ENGINE_EXE = OPENRADIOSS_PATH / "exec" / "engine_win64.exe"
TH_TO_CSV_EXE = OPENRADIOSS_PATH / "exec" / "th_to_csv_win64.exe"

MODEL_DIR = Path("D:/rad")
STARTER_FILE = "Bumper_Beam_AP_meshed_0000.rad"
ENGINE_FILE =  "Bumper_Beam_AP_meshed_0001.rad"

# Time history file (output from simulation)
TH_FILE = MODEL_DIR / "Bumper_Beam_AP_meshedT01"
# CSV output file
CSV_FILE = MODEL_DIR / "results.csv"

SETVARS_PATH = Path("C:/Program Files (x86)/Intel/oneAPI/setvars.bat")
OMP_NUM_THREADS = "1"
KMP_STACKSIZE = "400m"

# ============================================================================
# ENVIRONMENT SETUP
# ============================================================================

def setup_environment():
    env = os.environ.copy()
    env["OPENRADIOSS_PATH"] = str(OPENRADIOSS_PATH)
    env["RAD_CFG_PATH"] = str(OPENRADIOSS_PATH / "hm_cfg_files")
    env["RAD_H3D_PATH"] = str(OPENRADIOSS_PATH / "extlib" / "h3d" / "lib" / "win64")
    env["OMP_NUM_THREADS"] = OMP_NUM_THREADS
    env["KMP_STACKSIZE"] = KMP_STACKSIZE

    hm_reader = OPENRADIOSS_PATH / "extlib" / "hm_reader" / "win64"
    if hm_reader.exists():
        env["PATH"] = str(hm_reader) + ";" + env.get("PATH", "")

    # Add tools directory to PATH for th_to_csv
    tools_dir = OPENRADIOSS_PATH / "tools"
    if tools_dir.exists():
        env["PATH"] = str(tools_dir) + ";" + env.get("PATH", "")

    return env

def run_cmd(cmd, cwd, env, log_file):
    """Run command and capture output to log file"""
    with open(log_file, 'w') as f:
        result = subprocess.run(cmd, shell=True, cwd=cwd, env=env,
                                stdout=f, stderr=subprocess.STDOUT, text=True)
    return result.returncode

def convert_th_to_csv(th_file, csv_file, env):
    """Convert time history binary file to CSV format"""
    if not th_file.exists():
        print(f"Warning: Time history file not found: {th_file}")
        return False

    if not TH_TO_CSV_EXE.exists():
        print(f"Warning: th_to_csv_win64.exe not found at {TH_TO_CSV_EXE}")
        return False

    print(f"Converting time history: {th_file.name} -> {csv_file.name}")

    # Run th_to_csv and redirect output to CSV file
    cmd = f'"{TH_TO_CSV_EXE}" "{th_file}"'

    try:
        with open(csv_file, 'w') as f:
            result = subprocess.run(cmd, shell=True, cwd=str(MODEL_DIR), env=env,
                                    stdout=f, stderr=subprocess.PIPE, text=True)

        if result.returncode == 0 and csv_file.exists() and csv_file.stat().st_size > 0:
            # Count lines to verify data
            with open(csv_file, 'r') as f:
                line_count = sum(1 for _ in f)
            print(f"  [OK] Created {csv_file.name} ({line_count} lines, {csv_file.stat().st_size / 1024:.1f} KB)")

            # Show first few lines as preview
            with open(csv_file, 'r') as f:
                header = f.readline().strip()
                first_data = f.readline().strip() if line_count > 1 else ""
            print(f"  Header: {header[:100]}...")
            return True
        else:
            print(f"  [FAILED] Conversion failed (exit code {result.returncode})")
            if result.stderr:
                print(f"    Error: {result.stderr[:200]}")
            return False
    except Exception as e:
        print(f"  [ERROR] {e}")
        return False

# ============================================================================
# MAIN EXECUTION
# ============================================================================

def main():
    print("=" * 60)
    print("OpenRadioss Bumper Beam Simulation")
    print("=" * 60)

    # Quick verification
    if not STARTER_EXE.exists() or not ENGINE_EXE.exists():
        print("ERROR: OpenRadioss executables not found")
        return 1

    env = setup_environment()
    setvars = f'call "{SETVARS_PATH}" intel64 vs2022 > nul 2>&1 && ' if SETVARS_PATH.exists() else ""

    # Run Starter
    print("\n[1/3] Running Starter...")
    starter_input = MODEL_DIR / STARTER_FILE
    rc = run_cmd(f'{setvars}"{STARTER_EXE}" -i "{starter_input}"',
                  str(MODEL_DIR), env, MODEL_DIR / "starter.log")
    if rc != 0:
        print(f"Starter failed (exit {rc}). Check starter.log")
        return rc

    # Run Engine
    print("[2/3] Running Engine...")
    engine_input = MODEL_DIR / ENGINE_FILE
    rc = run_cmd(f'{setvars}"{ENGINE_EXE}" -i "{engine_input}"',
                  str(MODEL_DIR), env, MODEL_DIR / "engine.log")
    if rc != 0:
        print(f"Engine failed (exit {rc}). Check engine.log")
        return rc

    # List animation files created
    anim_files = list(MODEL_DIR.glob("*.A0*")) + list(MODEL_DIR.glob("*.h3d"))
    if anim_files:
        print(f"\nAnimation files created ({len(anim_files)}):")
        for f in sorted(anim_files):
            size_kb = f.stat().st_size / 1024
            print(f"  {f.name} ({size_kb:.1f} KB)")
    else:
        print("\nWarning: No animation files found")

    # Convert time history to CSV
    print("\n[3/3] Converting time history to CSV...")
    convert_th_to_csv(TH_FILE, CSV_FILE, env)

    # Summary
    print("\n" + "=" * 60)
    print("SIMULATION COMPLETE")
    print("=" * 60)
    print(f"Results saved to: {MODEL_DIR}")
    print(f"  - Time history CSV: {CSV_FILE.name}")
    print(f"  - Starter log: starter.log")
    print(f"  - Engine log: engine.log")
    if anim_files:
        print(f"  - Animation files: {len(anim_files)} files")

    # Verify CSV was created
    if CSV_FILE.exists():
        print(f"\nCSV file size: {CSV_FILE.stat().st_size / 1024:.1f} KB")
        print("You can now open results.csv in Excel or Python for analysis.")

    print("\nDone.")
    return 0

if __name__ == "__main__":
    exit(main());
endsubmit;
run;

/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/


/*************************************************************************************************************************/
/* ============================================================                                                          */
/* OpenRadioss Bumper Beam Simulation                                                                                    */
/* ============================================================                                                          */
/*                                                                                                                       */
/* [1/3] Running Starter...                                                                                              */
/* [2/3] Running Engine...                                                                                               */
/*                                                                                                                       */
/* Warning: No animation files found                                                                                     */
/*                                                                                                                       */
/* [3/3] Converting time history to CSV...                                                                               */
/* Converting time history: Cell_Phone_DropT01 -> results.csv                                                            */
/*   [OK] Created results.csv (6 lines, 0.2 KB)                                                                          */
/*                                                                                                                       */
/*   Header: ...                                                                                                         */
/*                                                                                                                       */
/* ============================================================                                                          */
/* SIMULATION COMPLETE                                                                                                   */
/* ============================================================                                                          */
/*                                                                                                                       */
/* Results saved to: D:\rad                                                                                              */
/*                                                                                                                       */
/*   - Time history CSV: results.csv                                                                                     */
/*   - Starter log: starter.log                                                                                          */
/*   - Engine log: engine.log                                                                                            */
/*                                                                                                                       */
/*                                                                                                                       */
/* CSV file size: 0.2 KB                                                                                                 */
/* You can now open results.csv in Excel or Python for analysis.                                                         */
/*                                                                                                                       */
/* Done.                                                                                                                 */
/*                                                                                                                       */
/* ======================================================================================================================*/
/* DIRECTORY OF D:\RAD                                                                                                   */
/* ======================================================================================================================*/
/*                                                                                                                       */
/* Directory of d:\rad                                                                                                   */
/*                                                                                                                       */
/* Bumper_Beam_AP_meshedA001               3,013,780                                                                     */
/* Bumper_Beam_AP_meshedA002               3,013,780                                                                     */
/* Bumper_Beam_AP_meshedA003               3,013,780                                                                     */
/* ...                                                                                                                   */
/* Bumper_Beam_AP_meshedA099               3,013,780                                                                     */
/* Bumper_Beam_AP_meshedA100               3,013,780                                                                     */
/* Bumper_Beam_AP_meshedA101               3,013,780                                                                     */
/*                                                                                                                       */
/* Bumper_Beam_AP_meshedT01                  295,784                                                                     */
/* Bumper_Beam_AP_meshedT01.csv              788,949                                                                     */
/* Bumper_Beam_AP_meshed_0000.out            490,361                                                                     */
/* Bumper_Beam_AP_meshed_0000.rad          1,779,784                                                                     */
/* Bumper_Beam_AP_meshed_0000_0001.rst    28,158,031                                                                     */
/* Bumper_Beam_AP_meshed_0001.out            160,255                                                                     */
/* Bumper_Beam_AP_meshed_0001.rad                749                                                                     */
/* Bumper_Beam_AP_meshed_0001_0001.rst    28,162,839                                                                     */
/* global_energy_data.csv                      6,154                                                                     */
/* results.csv                                   150                                                                     */
/* starter.log                                 4,612                                                                     */
/* engine.log                                144,850                                                                     */
/*                                                                                                                       */
/* ======================================================================================================================*/
/* STARTER LOG                                                                                                           */
/* ======================================================================================================================*/
/* ************************************************************************                                              */
/* **                        OpenRadioss Starter                         **                                              */
/* **            Non-linear Finite Element Analysis Software             **                                              */
/* **                                                                    **                                              */
/* **                  Windows 64 bits, Intel compiler                   **                                              */
/* **                      Double Precision Version                      **                                              */
/* **                                                                    **                                              */
/* ************************************************************************                                              */
/* ** OpenRadioss Software                                               **                                              */
/* ** COPYRIGHT (C) 1986-2026 Altair Engineering, Inc.                   **                                              */
/* ** Licensed under GNU Affero General Public License.                  **                                              */
/* ** See License file.                                                  **                                              */
/* ************************************************************************                                              */
/*                                                                                                                       */
/*  .. UNITS SYSTEM                                                                                                      */
/*  .. CONTROL VARIABLES                                                                                                 */
/*  .. STARTER RUNNING ON    1 THREAD                                                                                    */
/*  .. FUNCTIONS & TABLES                                                                                                */
/*  .. MATERIALS                                                                                                         */
/*  .. NODES                                                                                                             */
/*  .. PROPERTIES                                                                                                        */
/*  .. 3D SHELL ELEMENTS                                                                                                 */
/*  .. 3D SPRING ELEMENTS                                                                                                */
/*  .. 3D TRIANGULAR SHELL ELEMENTS                                                                                      */
/*  .. SUBSETS                                                                                                           */
/*  .. ELEMENT GROUPS                                                                                                    */
/*  .. PART GROUPS                                                                                                       */
/*  .. SURFACES                                                                                                          */
/*  .. NODE GROUP                                                                                                        */
/*  .. BOUNDARY CONDITIONS                                                                                               */
/*  .. ACCELEROMETERS                                                                                                    */
/*  .. INITIAL VELOCITIES                                                                                                */
/*  .. DOMAIN DECOMPOSITION                                                                                              */
/*  .. ELEMENT GROUPS                                                                                                    */
/*  .. INTERFACES                                                                                                        */
/*  .. INTERFACE BUFFER INITIALIZATION                                                                                   */
/*  .. RIGID WALLS                                                                                                       */
/*  .. RIGID BODIES                                                                                                      */
/*  .. RETURNS TO DOMAIN DECOMPOSITION FOR OPTIMIZATION                                                                  */
/*  .. DOMAIN DECOMPOSITION                                                                                              */
/*  .. ELEMENT GROUPS                                                                                                    */
/*  .. INTERFACES                                                                                                        */
/*  .. INTERFACE BUFFER INITIALIZATION                                                                                   */
/*                                                                                                                       */
/* WARNING ID :    343                                                                                                   */
/* ** WARNING: INITIAL PENETRATIONS IN INTERFACE                                                                         */
/*  .. RIGID WALLS                                                                                                       */
/*  .. RIGID BODIES                                                                                                      */
/*  .. ELEMENT BUFFER INITIALIZATION                                                                                     */
/*  .. SECTIONS                                                                                                          */
/*  .. GEOMETRY PLOT FILE                                                                                                */
/*  .. PARALLEL RESTART FILES GENERATION                                                                                 */
/*                                                                                                                       */
/* ------------------------------------------------------------------------                                              */
/*                    ** COMPUTE TIME INFORMATION **                                                                     */
/*                                                                                                                       */
/*  EXECUTION STARTED      :      2026/05/25  15:10:51                                                                   */
/*  EXECUTION COMPLETED    :      2026/05/25  15:10:52                                                                   */
/*                                                                                                                       */
/*  ELAPSED TIME...........=          1.60 s                                                                             */
/*                                00:00:01                                                                               */
/* ------------------------------------------------------------------------                                              */
/*                                                                                                                       */
/*      TERMINATION WITH WARNING                                                                                         */
/*      ------------------                                                                                               */
/*               0 ERROR(S)                                                                                              */
/*               1 WARNING(S)                                                                                            */
/*                                                                                                                       */
/*                                                                                                                       */
/* PLEASE CHECK LISTING FILE FOR FURTHER DETAILS                                                                         */
/*                                                                                                                       */
/* ======================================================================================================================*/
/* D:/RAD/ENGINE LOG                                                                                                    **/
/* ======================================================================================================================*/
/* ************************************************************************                                              */
/* **                         OpenRadioss Engine                         **                                              */
/* **            Non-linear Finite Element Analysis Software             **                                              */
/* **                                                                    **                                              */
/* **                  Windows 64 bits, Intel compiler                   **                                              */
/* **                      Double Precision Version                      **                                              */
/* **                                                                    **                                              */
/* ************************************************************************                                              */
/* ** OpenRadioss Software                                               **                                              */
/* ** COPYRIGHT (C) 1986-2026 Altair Engineering, Inc.                   **                                              */
/* ** Licensed under GNU Affero General Public License.                  **                                              */
/* ** See License file.                                                  **                                              */
/* ************************************************************************                                              */
/*                                                                                                                       */
/*  ROOT: Bumper_Beam_AP_meshed  RESTART: 0001                                                                           */
/*  NUMBER OF HMPP PROCESSES     1                                                                                       */
/*  25/05/2026                                                                                                           */
/*  NC=       0 T= 0.0000E+00 DT= 1.0000E-03 ERR=  0.0% DM/M= 2.0556E-04                                                 */
/*      ANIMATION FILE: Bumper_Beam_AP_meshedA001 WRITTEN                                                                */
/*  NC=     100 T= 1.0000E-01 DT= 1.0000E-03 ERR= -0.0% DM/M= 2.0556E-04                                                 */
/*  ELAPSED TIME=          2.02 s  REMAINING TIME=       2014.57 s                                                       */
/*  NC=     200 T= 2.0000E-01 DT= 1.0000E-03 ERR= -0.0% DM/M= 2.0556E-04                                                 */
/*  ELAPSED TIME=          3.76 s  REMAINING TIME=       1878.71 s                                                       */
/*  NC=     300 T= 3.0000E-01 DT= 1.0000E-03 ERR= -0.0% DM/M= 2.0556E-04                                                 */
/*  ELAPSED TIME=          5.52 s  REMAINING TIME=       1832.95 s                                                       */
/*  ....                                                                                                                 */
/*  ....                                                                                                                 */
/*                    ** MEMORY USAGE STATISTICS **                                                                      */
/*                                                                                                                       */
/*  TOTAL MEMORY USED .........................:       95 MB                                                             */
/*  MAXIMUM MEMORY PER PROCESSOR...............:       95 MB                                                             */
/*  MINIMUM MEMORY PER PROCESSOR...............:       95 MB                                                             */
/*  AVERAGE MEMORY PER PROCESSOR...............:       95 MB                                                             */
/*                                                                                                                       */
/*                    ** DISK USAGE STATISTICS **                                                                        */
/*                                                                                                                       */
/*  TOTAL DISK SPACE USED .....................:        317 MB                                                           */
/*  ANIMATION/H3D/TH/OUTP SIZE ................:        290 MB                                                           */
/*  RESTART FILE SIZE .........................:         26 MB                                                           */
/*                                                                                                                       */
/*  ELAPSED TIME     =       1773.12 s                                                                                   */
/*                           0:29:33                                                                                     */
/*                                                                                                                       */
/*      NORMAL TERMINATION                                                                                               */
/*      TOTAL NUMBER OF CYCLES  :  100001                                                                                */
/* ======================================================================================================================*/
/*  D:/RAD/RESULTS.CSV                                                                                                   */
/* ======================================================================================================================*/
/*  T01 TO CSV CONVERTER                                                                                                 */
/*                                                                                                                       */
/*  FILE           = D:\rad\Bumper_Beam_AP_meshedT01                                                                     */
/*  OUTPUT FILE    = D:\rad\Bumper_Beam_AP_meshedT01.csv                                                                 */
/*   ** CONVERSION COMPLETED                                                                                             */
/* ======================================================================================================================*/
/*  Cell_Phone_Drop CSVs                                                                                                 */
/* ======================================================================================================================*/
/*                                                                                                                       */
/*   d:/rad                                                                                                              */
/*      D:\rad\Bumper_Beam_AP_meshedT01,csv                                                                              */
/*      D:\rad\global_energy_data.csv                                                                                    */
/*      D:\rad\results.csv                                                                                               */
/*                                                                                                                       */
/*                                                                                                                       */
/* ======================================================================================================================*/
/*  D:\rad\Cell_Phone_DropT01.csv                                                                                        */
/* ======================================================================================================================*/
/*                                                                                                                       */
/*  Middle Observation(500 ) of table = workx.simout - Total Obs 1000                                                    */
/*                                                                                                                       */
/*   -- CHARACTER --                                                                                                     */
/*  Variable                        Typ    Value                                                                         */
/*                                                                                                                       */
/*  SIMULATION                       C14   Cell Drop Test                                                                */
/*                                                                                                                       */
/*   -- NUMERIC --                                                                                                       */
/*  TIME                             N8    0.0000499086                                                                  */
/*  INTERNAL_ENERGY                  N8        7.656168                                                                  */
/*  KINETIC_ENERGY                   N8        389.6605                                                                  */
/*  X_MOMENTUM                       N8      -0.0852198                                                                  */
/*  Y_MOMENTUM                       N8     -0.09353658                                                                  */
/*  Z_MOMENTUM                       N8     -0.07004944                                                                  */
/*  MASS                             N8    0.0000270143                                                                  */
/*  TIME_STEP                        N8      9.90443E-9                                                                  */
/*  ROTATION_ENERGY                  N8               0                                                                  */
/*  EXTERNAL_WORK                    N8      -0.1683699                                                                  */
/*  SPRING_ENERGY                    N8               0                                                                  */
/*  CONTACT_ENERGY                   N8    0.0008799649                                                                  */
/*  HOURGLASS_ENERGY                 N8    3.031299E-13                                                                  */
/*  ELASTIC_CONTACT_ENERGY           N8    0.0008779599                                                                  */
/*  FRICTIONAL_CONTACT_ENERGY        N8               0                                                                  */
/*  DAMPING_CONTACT_ENERGY           N8     2.004972E-6                                                                  */
/*  PLASTIC_WORK                     N8        1.035731                                                                  */
/*  ADDED_MASS                       N8    -1.93124E-18                                                                  */
/*  PERCENTAGE_ADDED_MASS            N8    -7.14893E-12                                                                  */
/*  INLET_MASS                       N8               0                                                                  */
/*  OUTLET_MASS                      N8               0                                                                  */
/*  INLET_ENERGY                     N8               0                                                                  */
/*  OUTLET_ENERGY                    N8               0                                                                  */
/*  ENERGY_BALANCE                   N8    -2359.784427                                                                  */
/*  PLASTIC_FRACTION                 N8    0.1352805999                                                                  */
/*************************************************************************************************************************/

/*                                    _ _                 _
  ___  _ __   ___ _ __  _ __ __ _  __| (_) ___  ___ ___  | | ___   __ _
 / _ \| `_ \ / _ \ `_ \| `__/ _` |/ _` | |/ _ \/ __/ __| | |/ _ \ / _` |
| (_) | |_) |  __/ | | | | | (_| | (_| | | (_) \__ \__ \ | | (_) | (_| |
 \___/| .__/ \___|_| |_|_|  \__,_|\__,_|_|\___/|___/___/ |_|\___/ \__, |
      |_|                                                         |___/
*/

1                                          Altair SLC            15:10 Monday, May 25, 2026

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿ods _all_ close;
           ^
ERROR: Expected a statement keyword : found "?"

NOTE: AUTOEXEC processing completed

1         /*--- CREATE SIEMEN ANIMATION AND TIME HISTORY CSV FILE  ---*/
2
3         options validvarname=v7;
4         options set=PYTHONHOME "D:\py314";
5         proc python;
6         submit;
7         import os
8         import pandas as pd
9         import subprocess
10        from pathlib import Path
11
12        # ============================================================================
13        # CONFIGURATION
14        # ============================================================================
15
16        OPENRADIOSS_PATH = Path("C:/openradioss")
17        STARTER_EXE = OPENRADIOSS_PATH / "exec" / "starter_win64.exe"
18        ENGINE_EXE = OPENRADIOSS_PATH / "exec" / "engine_win64.exe"
19        TH_TO_CSV_EXE = OPENRADIOSS_PATH / "exec" / "th_to_csv_win64.exe"
20
21        MODEL_DIR = Path("D:/rad")
22        STARTER_FILE = "Bumper_Beam_AP_meshed_0000.rad"
23        ENGINE_FILE =  "Bumper_Beam_AP_meshed_0001.rad"
24
25        # Time history file (output from simulation)
26        TH_FILE = MODEL_DIR / "Bumper_Beam_AP_meshedT01"
27        # CSV output file
28        CSV_FILE = MODEL_DIR / "results.csv"
29
30        SETVARS_PATH = Path("C:/Program Files (x86)/Intel/oneAPI/setvars.bat")
31        OMP_NUM_THREADS = "1"
32        KMP_STACKSIZE = "400m"
33
34        # ============================================================================
35        # ENVIRONMENT SETUP
36        # ============================================================================
37
38        def setup_environment():
39            env = os.environ.copy()
40            env["OPENRADIOSS_PATH"] = str(OPENRADIOSS_PATH)
41            env["RAD_CFG_PATH"] = str(OPENRADIOSS_PATH / "hm_cfg_files")
42            env["RAD_H3D_PATH"] = str(OPENRADIOSS_PATH / "extlib" / "h3d" / "lib" / "win64")
43            env["OMP_NUM_THREADS"] = OMP_NUM_THREADS
44            env["KMP_STACKSIZE"] = KMP_STACKSIZE
45
46            hm_reader = OPENRADIOSS_PATH / "extlib" / "hm_reader" / "win64"
47            if hm_reader.exists():
48                env["PATH"] = str(hm_reader) + ";" + env.get("PATH", "")
49
50            # Add tools directory to PATH for th_to_csv
51            tools_dir = OPENRADIOSS_PATH / "tools"
52            if tools_dir.exists():
53                env["PATH"] = str(tools_dir) + ";" + env.get("PATH", "")
54
55            return env
56
57        def run_cmd(cmd, cwd, env, log_file):
58            """Run command and capture output to log file"""
59            with open(log_file, 'w') as f:
60                result = subprocess.run(cmd, shell=True, cwd=cwd, env=env,
61                                        stdout=f, stderr=subprocess.STDOUT, text=True)
62            return result.returncode
63
64        def convert_th_to_csv(th_file, csv_file, env):
65            """Convert time history binary file to CSV format"""
66            if not th_file.exists():
67                print(f"Warning: Time history file not found: {th_file}")
68                return False
69
70            if not TH_TO_CSV_EXE.exists():
71                print(f"Warning: th_to_csv_win64.exe not found at {TH_TO_CSV_EXE}")
72                return False
73
74            print(f"Converting time history: {th_file.name} -> {csv_file.name}")
75
76            # Run th_to_csv and redirect output to CSV file
77            cmd = f'"{TH_TO_CSV_EXE}" "{th_file}"'
78
79            try:
80                with open(csv_file, 'w') as f:
81                    result = subprocess.run(cmd, shell=True, cwd=str(MODEL_DIR), env=env,
82                                            stdout=f, stderr=subprocess.PIPE, text=True)
83
84                if result.returncode == 0 and csv_file.exists() and csv_file.stat().st_size > 0:
85                    # Count lines to verify data
86                    with open(csv_file, 'r') as f:
87                        line_count = sum(1 for _ in f)
88                    print(f"  [OK] Created {csv_file.name} ({line_count} lines, {csv_file.stat().st_size / 1024:.1f} KB)")
89
90                    # Show first few lines as preview
91                    with open(csv_file, 'r') as f:
92                        header = f.readline().strip()
93                        first_data = f.readline().strip() if line_count > 1 else ""
94                    print(f"  Header: {header[:100]}...")
95                    return True
96                else:
97                    print(f"  [FAILED] Conversion failed (exit code {result.returncode})")
98                    if result.stderr:
99                        print(f"    Error: {result.stderr[:200]}")
100                   return False
101           except Exception as e:
102               print(f"  [ERROR] {e}")
103               return False
104
105       # ============================================================================
106       # MAIN EXECUTION
107       # ============================================================================
108
109       def main():
110           print("=" * 60)
111           print("OpenRadioss Bumper Beam Simulation")
112           print("=" * 60)
113
114           # Quick verification
115           if not STARTER_EXE.exists() or not ENGINE_EXE.exists():
116               print("ERROR: OpenRadioss executables not found")
117               return 1
118
119           env = setup_environment()
120           setvars = f'call "{SETVARS_PATH}" intel64 vs2022 > nul 2>&1 && ' if SETVARS_PATH.exists() else ""
121
122           # Run Starter
123           print("\n[1/3] Running Starter...")
124           starter_input = MODEL_DIR / STARTER_FILE
125           rc = run_cmd(f'{setvars}"{STARTER_EXE}" -i "{starter_input}"',
126                         str(MODEL_DIR), env, MODEL_DIR / "starter.log")
127           if rc != 0:
128               print(f"Starter failed (exit {rc}). Check starter.log")
129               return rc
130
131           # Run Engine
132           print("[2/3] Running Engine...")
133           engine_input = MODEL_DIR / ENGINE_FILE
134           rc = run_cmd(f'{setvars}"{ENGINE_EXE}" -i "{engine_input}"',
135                         str(MODEL_DIR), env, MODEL_DIR / "engine.log")
136           if rc != 0:
137               print(f"Engine failed (exit {rc}). Check engine.log")
138               return rc
139
140           # List animation files created
141           anim_files = list(MODEL_DIR.glob("*.A0*")) + list(MODEL_DIR.glob("*.h3d"))
142           if anim_files:
143               print(f"\nAnimation files created ({len(anim_files)}):")
144               for f in sorted(anim_files):
145                   size_kb = f.stat().st_size / 1024
146                   print(f"  {f.name} ({size_kb:.1f} KB)")
147           else:
148               print("\nWarning: No animation files found")
149
150           # Convert time history to CSV
151           print("\n[3/3] Converting time history to CSV...")
152           convert_th_to_csv(TH_FILE, CSV_FILE, env)
153
154           # Summary
155           print("\n" + "=" * 60)
156           print("SIMULATION COMPLETE")
157           print("=" * 60)
158           print(f"Results saved to: {MODEL_DIR}")
159           print(f"  - Time history CSV: {CSV_FILE.name}")
160           print(f"  - Starter log: starter.log")
161           print(f"  - Engine log: engine.log")
162           if anim_files:
163               print(f"  - Animation files: {len(anim_files)} files")
164
165           # Verify CSV was created
166           if CSV_FILE.exists():
167               print(f"\nCSV file size: {CSV_FILE.stat().st_size / 1024:.1f} KB")
168               print("You can now open results.csv in Excel or Python for analysis.")
169
170           print("\nDone.")
171           return 0
172
173       if __name__ == "__main__":
174           exit(main());
175       endsubmit;

NOTE: Submitting statements to Python:


176       run;
NOTE: Procedure python step took :
      real time : 29:45.834
      cpu time  : 0:00.031


177
178
ERROR: Error printed on page 1

NOTE: Submitted statements took :
      real time : 29:45.944
      cpu time  : 0:00.093


/*  _                      _          _     _     _                    _        _     _
| || |     ___ _____   __ | |_ ___   | |__ (_)___| |_ ___  _ __ _   _ | |_ __ _| |__ | | ___
| || |_   / __/ __\ \ / / | __/ _ \  | `_ \| / __| __/ _ \| `__| | | || __/ _` | `_ \| |/ _ \
|__   _| | (__\__ \\ V /  | || (_) | | | | | \__ \ || (_) | |  | |_| || || (_| | |_) | |  __/
   |_|    \___|___/ \_/    \__\___/  |_| |_|_|___/\__\___/|_|   \__, | \__\__,_|_.__/|_|\___|
                                                                |___/
*/

options ls=255;
data workx.simraw ;

 retain simulation "Bumper Beam";

 infile 'D:\rad\Bumper_Beam_AP_meshedT01.csv' delimiter = ',' MISSOVER DSD lrecl=384 firstobs=2 ;

  informat
    TIME
    INTERNAL_ENERGY
    KINETIC_ENERGY
    X_MOMENTUM
    Y_MOMENTUM
    Z_MOMENTUM
    MASS
    TIME_STEP
    ROTATION_ENERGY
    EXTERNAL_WORK
    SPRING_ENERGY
    CONTACT_ENERGY
    HOURGLASS_ENERGY
    ELASTIC_CONTACT_ENERGY
    FRICTIONAL_CONTACT_ENERGY
    DAMPING_CONTACT_ENERGY
    PLASTIC_WORK
    ADDED_MASS
    PERCENTAGE_ADDED_MASS
    INLET_MASS
    OUTLET_MASS
    INLET_ENERGY
    OUTLET_ENERGY  best32.;

   input
     time
     INTERNAL_ENERGY
     KINETIC_ENERGY
     X_MOMENTUM
     Y_MOMENTUM
     Z_MOMENTUM
     MASS
     TIME_STEP
     ROTATION_ENERGY
     EXTERNAL_WORK
     SPRING_ENERGY
     CONTACT_ENERGY
     HOURGLASS_ENERGY
     ELASTIC_CONTACT_ENERGY
     FRICTIONAL_CONTACT_ENERGY
     DAMPING_CONTACT_ENERGY
     PLASTIC_WORK
     ADDED_MASS
     PERCENTAGE_ADDED_MASS
     INLET_MASS
     OUTLET_MASS
     INLET_ENERGY
     OUTLET_ENERGY
     ;
 /*drop
    ADDED_MASS
    CONTACT_ENERGY
    DAMPING_CONTACT_ENERGY
    ELASTIC_CONTACT_ENERGY
    FRICTIONAL_CONTACT_ENERGY
    HOURGLASS_ENERGY
    INLET_ENERGY
    INLET_MASS
    MASS
    OUTLET_ENERGY
    OUTLET_MASS
    PERCENTAGE_ADDED_MASS
    ROTATION_ENERGY
    SPRING_ENERGY
    Z_MOMENTUM */
    ;
run;quit;

data workx.simout;

    set workx.simraw;

    /* Energy balance ratio */
    ENERGY_BALANCE = (INTERNAL_ENERGY + KINETIC_ENERGY) / EXTERNAL_WORK;

    /* Plastic work fraction */
    PLASTIC_FRACTION = PLASTIC_WORK / INTERNAL_ENERGY;

    /* Time step change flag */
    TIME_STEP_CHANGE = dif(TIME_STEP);

    label ENERGY_BALANCE = "Energy Balance Ratio"
          PLASTIC_FRACTION = "Plastic Work Fraction";
run;


options ls=255;
/* Generate summary statistics */
proc means data=workx.simout n mean std min max;
run;

The MEANS Procedure

Variable                     Label                       N            Mean         Std Dev         Minimum         Maximum
--------------------------------------------------------------------------------------------------------------------------
TIME                                                  1000      49.9502200      28.8820214               0      99.9003600
INTERNAL_ENERGY                                       1000         4570.70         1858.72               0         6331.47
KINETIC_ENERGY                                        1000         1808.56         1908.79       0.0137701         6491.72
X_MOMENTUM                                            1000        -1031.55     893.1452423        -2596.69     408.8789000
Y_MOMENTUM                                            1000      -0.0114113       0.0601657      -0.2765227       0.1488477
Z_MOMENTUM                                            1000      -0.1640687       0.4232902      -2.2899570       3.8585120
MASS                                                  1000     519.3416889       0.0010673     519.3375000     519.3425000
TIME_STEP                                             1000       0.0010000    5.3599776E-9       0.0010000       0.0010001
ROTATION_ENERGY                                       1000       0.1876500       0.0903035               0       0.5371551
EXTERNAL_WORK                                         1000     -98.8938288      43.6155859    -141.8991000     0.000183170
SPRING_ENERGY                                         1000      52.8189393      17.5574742               0      67.6821500
CONTACT_ENERGY                                        1000      14.3683417       6.9661996               0      21.0974700
HOURGLASS_ENERGY                                      1000               0               0               0               0
ELASTIC_CONTACT_ENERGY                                1000       4.2614775       1.4020368               0       6.2147740
FRICTIONAL_CONTACT_ENERGY                             1000      10.1068642       5.9949155               0      16.6508400
DAMPING_CONTACT_ENERGY                                1000               0               0               0               0
PLASTIC_WORK                                          1000         4100.85         1749.60               0         5763.69
ADDED_MASS                                            1000       0.1108759       0.0010577       0.1067349       0.1117223
PERCENTAGE_ADDED_MASS                                 1000       0.0213539     0.000203712       0.0205564       0.0215169
INLET_MASS                                            1000               0               0               0               0
OUTLET_MASS                                           1000               0               0               0               0
INLET_ENERGY                                          1000               0               0               0               0
OUTLET_ENERGY                                         1000               0               0               0               0
ENERGY_BALANCE               Energy Balance Ratio      999      1107926.04     24355421.41       -23786.99       737733904
PLASTIC_FRACTION             Plastic Work Fraction     999       0.8618005       0.1316958               0       0.9343206
TIME_STEP_CHANGE                                       999    4.004004E-12    4.9716616E-9         -3.7E-8          3.9E-8
--------------------------------------------------------------------------------------------------------------------------


/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

1                                          Altair SLC           14:27 Tuesday, May 26, 2026

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿ods _all_ close;
           ^
ERROR: Expected a statement keyword : found "?"

NOTE: AUTOEXEC processing completed

1          options ls=255;
2         data workx.simraw ;
3
4          retain simulation "Bumper Beam";
5
6          infile 'D:\rad\Bumper_Beam_AP_meshedT01.csv' delimiter = ',' MISSOVER DSD lrecl=384 firstobs=2 ;
7
8           informat
9             TIME
10            INTERNAL_ENERGY
11            KINETIC_ENERGY
12            X_MOMENTUM
13            Y_MOMENTUM
14            Z_MOMENTUM
15            MASS
16            TIME_STEP
17            ROTATION_ENERGY
18            EXTERNAL_WORK
19            SPRING_ENERGY
20            CONTACT_ENERGY
21            HOURGLASS_ENERGY
22            ELASTIC_CONTACT_ENERGY
23            FRICTIONAL_CONTACT_ENERGY
24            DAMPING_CONTACT_ENERGY
25            PLASTIC_WORK
26            ADDED_MASS
27            PERCENTAGE_ADDED_MASS
28            INLET_MASS
29            OUTLET_MASS
30            INLET_ENERGY
31            OUTLET_ENERGY  best32.;
32
33           input
34             time
35             INTERNAL_ENERGY
36             KINETIC_ENERGY
37             X_MOMENTUM
38             Y_MOMENTUM
39             Z_MOMENTUM
40             MASS
41             TIME_STEP
42             ROTATION_ENERGY
43             EXTERNAL_WORK
44             SPRING_ENERGY
45             CONTACT_ENERGY
46             HOURGLASS_ENERGY
47             ELASTIC_CONTACT_ENERGY
48             FRICTIONAL_CONTACT_ENERGY
49             DAMPING_CONTACT_ENERGY
50             PLASTIC_WORK
51             ADDED_MASS
52             PERCENTAGE_ADDED_MASS
53             INLET_MASS
54             OUTLET_MASS
55             INLET_ENERGY
56             OUTLET_ENERGY
57             ;
58         /*drop
59            ADDED_MASS
60            CONTACT_ENERGY
61            DAMPING_CONTACT_ENERGY
62            ELASTIC_CONTACT_ENERGY
63            FRICTIONAL_CONTACT_ENERGY
64            HOURGLASS_ENERGY
65            INLET_ENERGY
66            INLET_MASS
67            MASS
68            OUTLET_ENERGY
69            OUTLET_MASS
70            PERCENTAGE_ADDED_MASS
71            ROTATION_ENERGY
72            SPRING_ENERGY
73            Z_MOMENTUM */
74            ;
75        run;

NOTE: The infile 'D:\rad\Bumper_Beam_AP_meshedT01.csv' is:
      Filename='D:\rad\Bumper_Beam_AP_meshedT01.csv',
      Owner Name=SLC\suzie,
      File size (bytes)=788949,
      Create Time=15:40:30 May 25 2026,
      Last Accessed=14:26:43 May 26 2026,
      Last Modified=15:40:31 May 25 2026,
      Lrecl=384, Recfm=V

NOTE: 1000 records were read from file 'D:\rad\Bumper_Beam_AP_meshedT01.csv'
      The minimum record length was 384
      The maximum record length was 384
NOTE: Data set "WORKX.simraw" has 1000 observation(s) and 24 variable(s)
NOTE: The data step took :
      real time : 0.063
      cpu time  : 0.015


75      !     quit;
76
77        data workx.simout;
78
79            set workx.simraw;
80
81            /* Energy balance ratio */
82            ENERGY_BALANCE = (INTERNAL_ENERGY + KINETIC_ENERGY) / EXTERNAL_WORK;
83
84            /* Plastic work fraction */
85            PLASTIC_FRACTION = PLASTIC_WORK / INTERNAL_ENERGY;
86
87            /* Time step change flag */
88            TIME_STEP_CHANGE = dif(TIME_STEP);
89
90            label ENERGY_BALANCE = "Energy Balance Ratio"
91                  PLASTIC_FRACTION = "Plastic Work Fraction";
92        run;

NOTE: A divide by zero condition was detected at line 82 column 57
NOTE: Missing values resulted from performing arithmetic upon missing values.
      Each place is given by: (Number of times) at (Line):(Column)
      1 at 85:37   1 at 88:24
NOTE: 1000 observations were read from "WORKX.simraw"
NOTE: Data set "WORKX.simout" has 1000 observation(s) and 27 variable(s)
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.015


93
94
95        options ls=255;
96        /* Generate summary statistics */
97        proc means data=workx.simout n mean std min max;
98        run;
NOTE: 1000 observations were read from "WORKX.simout"
NOTE: Procedure means step took :
      real time : 0.095
      cpu time  : 0.093


ERROR: Error printed on page 1

NOTE: Submitted statements took :
      real time : 0.316
      cpu time  : 0.187

/*___                                       _       _
| ___|  _ __ ___   __ _ _ __  _   _   _ __ | | ___ | |_ ___
|___ \ | `_ ` _ \ / _` | `_ \| | | | | `_ \| |/ _ \| __/ __|
 ___) || | | | | | (_| | | | | |_| | | |_) | | (_) | |_\__ \
|____/ |_| |_| |_|\__,_|_| |_|\__, | | .__/|_|\___/ \__|___/
                              |___/  |_|
*/

%utlfkil(d:/rad/energy_evolution.png);

ods listing close;
ods graphics on / reset=all imagename="energy_evolution" outputfmt=png;
ods printer file="d:/rad/energy_evolution.png" dpi=100;
proc sgplot data=workx.simout;

    title "Energy Evolution - Early Phase (First 1 Time Unit)";
    title2 "Internal vs Kinetic Energy";

    series x=time y=INTERNAL_ENERGY /
           lineattrs=(color=blue thickness=2)
           name="Internal"
           legendlabel="Internal Energy";

    series x=time y=KINETIC_ENERGY /
           lineattrs=(color=red thickness=2)
           y2axis
           name="Kinetic"
           legendlabel="Kinetic Energy";

    series x=time y=PLASTIC_WORK /
           lineattrs=(color=green thickness=2 pattern=shortdash)
           name="Plastic"
           legendlabel="Plastic Work";


    xaxis label="Time" grid;
    yaxis label="Internal Energy & Plastic Work" grid;
    y2axis label="Kinetic Energy";

run;

ods printer close;
ods graphics off;
ods listing;


%utlfkil(d:/rad/ymomentumevolve.png);

ods listing close;
ods graphics on / reset=all imagename="ymomentumevolve" outputfmt=png;
ods printer file="d:/rad/ymomentumevolve.png" dpi=100;

proc sgplot data=workx.simout;
    title "Y-Momentum Evolution";
    title2 "Primary Direction Impulse";

    series x=time y=Y_MOMENTUM /
           lineattrs=(color=darkblue thickness=2)
           markerattrs=(color=darkblue symbol=circlefilled size=5);

    xaxis label="Time" grid;
    yaxis label="Y-Momentum" grid;
run;

ods printer close;
ods _all_ close;
ods listing;


%utlfkil(d:/rad/xmomentumevolve.png);

ods listing close;
ods graphics on / reset=all imagename="xmomentumevolve" outputfmt=png;
ods printer file="d:/rad/xmomentumevolve.png" dpi=100;

proc sgplot data=workx.simout;
    title "X-Momentum Evolution";
    title2 "Primary Direction Impulse";

    series x=time y=X_MOMENTUM /
           lineattrs=(color=darkblue thickness=2)
           markerattrs=(color=darkblue symbol=circlefilled size=5);

    xaxis label="Time" grid;
    yaxis label="X-Momentum" grid;
run;

ods printer close;
ods _all_ close;
ods listing;


%utlfkil(d:/rad/timestephistory.png);

ods listing close;
ods graphics on / reset=all imagename="timestephistory" outputfmt=png;
ods printer file="d:/rad/timestephistory.png" dpi=100;

/* Time step history with change detection */
proc sgplot data=workx.simout;
    title "Time Step Evolution";
    title2 "Solver Adaptation to Simulation Complexity";

    /* Use scatter for better visibility of changes */
    scatter x=time y=TIME_STEP /
            markerattrs=(color=red symbol=circle size=6);

    /* Smooth line through the points */
    pbspline x=time y=TIME_STEP /
             lineattrs=(color=blue thickness=1)
             nomarkers;

    xaxis label="Time" grid;
    yaxis label="Time Step"
          type=log /* Log scale often helpful for time step */
          logbase=10
          logstyle=linear
          grid;

run;quit;

ods printer close;
ods graphics off;
ods listing;


%utlfkil(d:/rad/energybalance.png);

ods listing close;
ods graphics on / reset=all imagename="energybalance" outputfmt=png;
ods printer file="d:/rad/energybalance.png" dpi=100;

/* Energy conservation check */
proc sgplot data=workx.simout(where=(time>5));
    title "Energy Balance Beam Pushes Against Fixed Column";
    title2 "(Internal + Kinetic) / External Work";

    series x=time y=ENERGY_BALANCE /
           lineattrs=(color=black thickness=2);


    xaxis label="Time" ;
    yaxis label="Energy Balance Ratio"
           /*values=(-10 to 1  by 1)*/;
          ;

run;

ods printer close;
ods graphics off;
ods listing;


/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

1                                          Altair SLC           15:28 Tuesday, May 26, 2026

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿ods _all_ close;
           ^
ERROR: Expected a statement keyword : found "?"
NOTE: Library workx assigned as follows:
      Engine:        SAS7BDAT
      Physical Name: d:\wpswrkx

NOTE: Library wpdx assigned as follows:
      Engine:        WPD
      Physical Name: d:\wpswrkx

NOTE: Library slchelp assigned as follows:
      Engine:        WPD
      Physical Name: C:\Progra~1\Altair\SLC\2026\sashelp


LOG:  15:28:52
NOTE: 1 record was written to file PRINT

NOTE: The data step took :
      real time : 0.032
      cpu time  : 0.000


NOTE: Format num2mis output
NOTE: Format $chr2mis output
NOTE: Procedure format step took :
      real time : 0.015
      cpu time  : 0.015


NOTE: AUTOEXEC processing completed

1          %utlfkil(d:/rad/energy_evolution.png);
2
3         ods listing close;
4         ods graphics on / reset=all imagename="energy_evolution" outputfmt=png;
5         ods printer file="d:/rad/energy_evolution.png" dpi=100;
WARNING: ODS PRINTER is currently EXPERIMENTAL and is subject to change
6         proc sgplot data=workx.simout;
7
8             title "Energy Evolution - Early Phase (First 1 Time Unit)";
9             title2 "Internal vs Kinetic Energy";
10
11            series x=time y=INTERNAL_ENERGY /
12                   lineattrs=(color=blue thickness=2)
13                   name="Internal"
14                   legendlabel="Internal Energy";
15
16            series x=time y=KINETIC_ENERGY /
17                   lineattrs=(color=red thickness=2)
18                   y2axis
19                   name="Kinetic"
20                   legendlabel="Kinetic Energy";
21
22            series x=time y=PLASTIC_WORK /
23                   lineattrs=(color=green thickness=2 pattern=shortdash)
24                   name="Plastic"
25                   legendlabel="Plastic Work";
26
27
28            xaxis label="Time" grid;
29            yaxis label="Internal Energy & Plastic Work" grid;
30            y2axis label="Kinetic Energy";
31
32        run;
NOTE: Procedure sgplot step took :
      real time : 0.142
      cpu time  : 0.250


NOTE: Writing file d:\rad\energy_evolution.png
33
34        ods printer close;
35        ods graphics off;
36        ods listing;
37
38
39        %utlfkil(d:/rad/ymomentumevolve.png);
40
41        ods listing close;
42        ods graphics on / reset=all imagename="ymomentumevolve" outputfmt=png;
43        ods printer file="d:/rad/ymomentumevolve.png" dpi=100;
WARNING: ODS PRINTER is currently EXPERIMENTAL and is subject to change
44
45        proc sgplot data=workx.simout;
46            title "Y-Momentum Evolution";
47            title2 "Primary Direction Impulse";
48
49            series x=time y=Y_MOMENTUM /
50                   lineattrs=(color=darkblue thickness=2)
51                   markerattrs=(color=darkblue symbol=circlefilled size=5);
52
53            xaxis label="Time" grid;
54            yaxis label="Y-Momentum" grid;
55        run;
NOTE: Procedure sgplot step took :
      real time : 0.047
      cpu time  : 0.109


NOTE: Writing file d:\rad\ymomentumevolve.png
56
57        ods printer close;
58        ods _all_ close;
59        ods listing;
60
61
62        %utlfkil(d:/rad/xmomentumevolve.png);
63
64        ods listing close;
65        ods graphics on / reset=all imagename="xmomentumevolve" outputfmt=png;
66        ods printer file="d:/rad/xmomentumevolve.png" dpi=100;
WARNING: ODS PRINTER is currently EXPERIMENTAL and is subject to change
67
68        proc sgplot data=workx.simout;
69            title "X-Momentum Evolution";
70            title2 "Primary Direction Impulse";
71
72            series x=time y=X_MOMENTUM /
73                   lineattrs=(color=darkblue thickness=2)
74                   markerattrs=(color=darkblue symbol=circlefilled size=5);
75
76            xaxis label="Time" grid;
77            yaxis label="X-Momentum" grid;
78        run;
NOTE: Procedure sgplot step took :
      real time : 0.047
      cpu time  : 0.093


NOTE: Writing file d:\rad\xmomentumevolve.png
79
80        ods printer close;
81        ods _all_ close;
82        ods listing;
83
84
85        %utlfkil(d:/rad/timestephistory.png);
86
87        ods listing close;
88        ods graphics on / reset=all imagename="timestephistory" outputfmt=png;
89        ods printer file="d:/rad/timestephistory.png" dpi=100;
WARNING: ODS PRINTER is currently EXPERIMENTAL and is subject to change
90
91        /* Time step history with change detection */
92        proc sgplot data=workx.simout;
93            title "Time Step Evolution";
94            title2 "Solver Adaptation to Simulation Complexity";
95
96            /* Use scatter for better visibility of changes */
97            scatter x=time y=TIME_STEP /
98                    markerattrs=(color=red symbol=circle size=6);
99
100           /* Smooth line through the points */
101           pbspline x=time y=TIME_STEP /
102                    lineattrs=(color=blue thickness=1)
103                    nomarkers;
104
105           xaxis label="Time" grid;
106           yaxis label="Time Step"
107                 type=log /* Log scale often helpful for time step */
108                 logbase=10
109                 logstyle=linear
110                 grid;
111
112       run;quit;
NOTE: Procedure sgplot step took :
      real time : 0.126
      cpu time  : 0.250


NOTE: Writing file d:\rad\timestephistory.png
113
114       ods printer close;
115       ods graphics off;
116       ods listing;
117
118
119       %utlfkil(d:/rad/energybalance.png);
120
121       ods listing close;
122       ods graphics on / reset=all imagename="energybalance" outputfmt=png;
123       ods printer file="d:/rad/energybalance.png" dpi=100;
WARNING: ODS PRINTER is currently EXPERIMENTAL and is subject to change
124
125       /* Energy conservation check */
126       proc sgplot data=workx.simout(where=(time>5));
127           title "Energy Balance Beam Pushes Against Fixed Column";
128           title2 "(Internal + Kinetic) / External Work";
129
130           series x=time y=ENERGY_BALANCE /
131                  lineattrs=(color=black thickness=2);
132
133
134           xaxis label="Time" ;
135           yaxis label="Energy Balance Ratio"
136                  /*values=(-10 to 1  by 1)*/;
137                 ;
138
139       run;
NOTE: Procedure sgplot step took :
      real time : 0.047
      cpu time  : 0.125


NOTE: Writing file d:\rad\energybalance.png
140
141       ods printer close;
142       ods graphics off;
143       ods listing;
144
ERROR: Error printed on page 1

NOTE: Submitted statements took :
      real time : 0.901
      cpu time  : 1.593


/*__                    _                 _   _               _               _   _       __ _ _
 / /_    __ _ _ __ ___ (_)_ __ ___   __ _| |_(_) ___  _ __   | |_ ___  __   _| |_| | __  / _(_) | ___  ___
| `_ \  / _` | `_ ` _ \| | `_ ` _ \ / _` | __| |/ _ \| `_ \  | __/ _ \ \ \ / / __| |/ / | |_| | |/ _ \/ __|
| (_) || (_| | | | | | | | | | | | | (_| | |_| | (_) | | | | | || (_) | \ V /| |_|   <  |  _| | |  __/\__ \
 \___/  \__,_|_| |_| |_|_|_| |_| |_|\__,_|\__|_|\___/|_| |_|  \__\___/   \_/  \__|_|\_\ |_| |_|_|\___||___/
*/
*/

/*--- CONVERT ANIMATION FILES TO VTK ---*/

options validvarname=v7;
options set=PYTHONHOME "D:\py314";
proc python;
submit;
import subprocess
import os
from pathlib import Path

# Binary-safe conversion
rad_dir = Path("D:/rad")
converter = Path("C:/openradioss/exec/anim_to_vtk_win64.exe")

# Find all ANIM files (no extension, contains pattern)
anim_files = [f for f in rad_dir.iterdir()
              if f.is_file() and "Bumper_Beam_AP_meshedA" in f.name and f.suffix == ""]

for anim_file in sorted(anim_files):
    output_file = anim_file.with_suffix(".vtk")
    print(f"Converting: {anim_file.name}")

    # Binary-safe: Use subprocess with stdout capture as bytes
    result = subprocess.run(
        [str(converter), str(anim_file)],
        capture_output=True,
        check=False
    )

    # Write binary output directly (no text conversion)
    with open(output_file, 'wb') as f:
        f.write(result.stdout)

    if result.returncode == 0 and output_file.stat().st_size > 0:
        # Verify VTK header
        with open(output_file, 'rb') as f:
            if f.read(5) == b'# vtk':
                print(f"  [OK] Valid VTK file ({output_file.stat().st_size} bytes)")
            else:
                print(f"  [WARNING] Invalid VTK header")
    else:
        print(f"  [FAILED] Return code: {result.returncode}")
endsubmit;
run;

/**************************************************************************************************************************/
/*  Altair SLC                                                                                                            */
/*                                                                                                                        */
/* Converting: Cell_Phone_DropA001                                                                                        */
/*   [OK] Valid VTK file (63378912 bytes)                                                                                 */
/*                                                                                                                        */
/* Converting: Cell_Phone_DropA002                                                                                        */
/*   [OK] Valid VTK file (164322370 bytes)                                                                                */
/*                                                                                                                        */
/* Converting: Cell_Phone_DropA003                                                                                        */
/*   [OK] Valid VTK file (164949354 bytes)                                                                                */
/* ...                                                                                                                    */
/* ...                                                                                                                    */
/* Converting: Cell_Phone_DropA004                                                                                        */
/*   [OK] Valid VTK file (154571109 bytes)                                                                                */
/*                                                                                                                        */
/* Converting: Cell_Phone_DropA100                                                                                        */
/*   [OK] Valid VTK file (154524209 bytes)                                                                                */
/*                                                                                                                        */
/* Converting: Cell_Phone_DropA101                                                                                        */
/*   [OK] Valid VTK file (154473369 bytes)                                                                                */
/**************************************************************************************************************************/


/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

1                                          Altair SLC            16:33 Monday, May 25, 2026

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿ods _all_ close;
           ^
ERROR: Expected a statement keyword : found "?"

NOTE: AUTOEXEC processing completed

1          options validvarname=v7;
2         options set=PYTHONHOME "D:\py314";
3         proc python;
4         submit;
5         import subprocess
6         import os
7         from pathlib import Path
8
9         # Binary-safe conversion
10        rad_dir = Path("D:/rad")
11        converter = Path("C:/openradioss/exec/anim_to_vtk_win64.exe")
12
13        # Find all ANIM files (no extension, contains pattern)
14        anim_files = [f for f in rad_dir.iterdir()
15                      if f.is_file() and "Bumper_Beam_AP_meshedA" in f.name and f.suffix == ""]
16
17        for anim_file in sorted(anim_files):
18            output_file = anim_file.with_suffix(".vtk")
19            print(f"Converting: {anim_file.name}")
20
21            # Binary-safe: Use subprocess with stdout capture as bytes
22            result = subprocess.run(
23                [str(converter), str(anim_file)],
24                capture_output=True,
25                check=False
26            )
27
28            # Write binary output directly (no text conversion)
29            with open(output_file, 'wb') as f:
30                f.write(result.stdout)
31
32            if result.returncode == 0 and output_file.stat().st_size > 0:
33                # Verify VTK header
34                with open(output_file, 'rb') as f:
35                    if f.read(5) == b'# vtk':
36                        print(f"  [OK] Valid VTK file ({output_file.stat().st_size} bytes)")
37                    else:
38                        print(f"  [WARNING] Invalid VTK header")
39            else:
40                print(f"  [FAILED] Return code: {result.returncode}")
41        endsubmit;

NOTE: Submitting statements to Python:


42        run;
NOTE: Procedure python step took :
      real time : 3:50.656
      cpu time  : 0:00.062


ERROR: Error printed on page 1

NOTE: Submitted statements took :
      real time : 3:50.735
      cpu time  : 0:00.140

/*____         _   _      _                _   _    _         _  __
|___  | __   _| |_| | __ | |_ ___   __   _| |_| | _| |__   __| |/ _|
   / /  \ \ / / __| |/ / | __/ _ \  \ \ / / __| |/ / `_ \ / _` | |_
  / /    \ V /| |_|   <  | || (_) |  \ V /| |_|   <| | | | (_| |  _|
 /_/      \_/  \__|_|\_\  \__\___/    \_/  \__|_|\_\_| |_|\__,_|_|

*/

%slc_pvpybegin;
cards4;
#!/usr/bin/env python
"""
Convert a series of VTK files into a single, transient VTKHDF file.
This script is designed to be run with ParaView's pvpython executable.
"""

from paraview.simple import *
import os
import glob

def convert_vtk_series_to_vtkhdf(file_pattern, output_file, compression_level=4):
    """
    Convert a series of VTK files into a single VTKHDF file.

    Args:
        file_pattern (str): Glob pattern matching your VTK files (e.g., "path/to/anim_*.vtk").
        output_file (str): Output filename (must end with .vtkhdf).
        compression_level (int): Compression level (0-9) for the HDF5 file.
                                 4 provides a good balance between size and speed.
    """
    # Get list of files sorted alphabetically
    vtk_files = sorted(glob.glob(file_pattern))

    if not vtk_files:
        print(f"ERROR: No files found matching pattern '{file_pattern}'")
        return

    print(f"Found {len(vtk_files)} VTK files to convert.")

    # Create a reader for the file series
    # Using LegacyVTKReader for .vtk files
    print("Loading file series...")
    reader = LegacyVTKReader(FileNames=vtk_files)

    # Save the data as a VTKHDF file
    print(f"Saving to {output_file}...")
    SaveData(
        output_file,
        proxy=reader,
        WriteAllTimeSteps=1,      # Save all time steps into one file
        CompressionLevel=compression_level
    )
    print("Conversion complete!")


if __name__ == "__main__":
    # --- CONFIGURATION ---
    # Update these paths for your specific case
    INPUT_FILE_PATTERN = "D:/rad/Bumper_Beam_AP_meshed*.vtk"  # e.g., Cell_Phone_DropA001.vtk, A002.vtk, etc.
    OUTPUT_FILE = "D:/rad/Bumper_Beam_AP_meshed.vtkhdf"

    convert_vtk_series_to_vtkhdf(INPUT_FILE_PATTERN, OUTPUT_FILE)
;;;;
%slc_pvpyend;

/**************************************************************************************************************************/
/* Altair SLC                                                                                                             */
/* Found 101 VTK files to convert.                                                                                        */
/* Loading file series...                                                                                                 */
/* Saving to D:/rad/Cell_Phone_Drop.vtkhdf...                                                                             */
/* Conversion complete!                                                                                                   */
/**************************************************************************************************************************/

/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

1                                          Altair SLC            16:41 Monday, May 25, 2026

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿ods _all_ close;
           ^
ERROR: Expected a statement keyword : found "?"

NOTE: AUTOEXEC processing completed

1          %slc_pvpybegin;
The file c:/temp/py_pgm.py does not exist
2         cards4;

NOTE: The file 'c:\temp\py_pgmx.py' is:
      Filename='c:\temp\py_pgmx.py',
      Owner Name=SLC\suzie,
      File size (bytes)=0,
      Create Time=13:21:25 Jan 12 2026,
      Last Accessed=16:41:57 May 25 2026,
      Last Modified=16:41:57 May 25 2026,
      Lrecl=32767, Recfm=V

NOTE: 52 records were written to file 'c:\temp\py_pgmx.py'
      The minimum record length was 80
      The maximum record length was 109
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.015


3         #!/usr/bin/env python
4         """
5         Convert a series of VTK files into a single, transient VTKHDF file.
6         This script is designed to be run with ParaView's pvpython executable.
7         """
8
9         from paraview.simple import *
10        import os
11        import glob
12
13        def convert_vtk_series_to_vtkhdf(file_pattern, output_file, compression_level=4):
14            """
15            Convert a series of VTK files into a single VTKHDF file.
16
17            Args:
18                file_pattern (str): Glob pattern matching your VTK files (e.g., "path/to/anim_*.vtk").
19                output_file (str): Output filename (must end with .vtkhdf).
20                compression_level (int): Compression level (0-9) for the HDF5 file.
21                                         4 provides a good balance between size and speed.
22            """
23            # Get list of files sorted alphabetically
24            vtk_files = sorted(glob.glob(file_pattern))
25
26            if not vtk_files:
27                print(f"ERROR: No files found matching pattern '{file_pattern}'")
28                return
29
30            print(f"Found {len(vtk_files)} VTK files to convert.")
31
32            # Create a reader for the file series
33            # Using LegacyVTKReader for .vtk files
34            print("Loading file series...")
35            reader = LegacyVTKReader(FileNames=vtk_files)
36
37            # Save the data as a VTKHDF file
38            print(f"Saving to {output_file}...")
39            SaveData(
40                output_file,
41                proxy=reader,
42                WriteAllTimeSteps=1,      # Save all time steps into one file
43                CompressionLevel=compression_level
44            )
45            print("Conversion complete!")
46
47
48        if __name__ == "__main__":
49            # --- CONFIGURATION ---
50            # Update these paths for your specific case
51            INPUT_FILE_PATTERN = "D:/rad/Bumper_Beam_AP_meshed*.vtk"  # e.g., Cell_Phone_DropA001.vtk, A002.vtk, etc.
52            OUTPUT_FILE = "D:/rad/Bumper_Beam_AP_meshed.vtkhdf"
53
54            convert_vtk_series_to_vtkhdf(INPUT_FILE_PATTERN, OUTPUT_FILE)
55        ;;;;
56        %slc_pvpyend;

NOTE: The infile 'c:\temp\py_pgmx.py' is:
      Filename='c:\temp\py_pgmx.py',
      Owner Name=SLC\suzie,
      File size (bytes)=4310,
      Create Time=13:21:25 Jan 12 2026,
      Last Accessed=16:41:57 May 25 2026,
      Last Modified=16:41:57 May 25 2026,
      Lrecl=32767, Recfm=V

NOTE: The file 'c:\temp\py_pgm.py' is:
      Filename='c:\temp\py_pgm.py',
      Owner Name=SLC\suzie,
      File size (bytes)=0,
      Create Time=16:38:15 May 12 2026,
      Last Accessed=16:41:57 May 25 2026,
      Last Modified=16:41:57 May 25 2026,
      Lrecl=32767, Recfm=V

#!/usr/bin/env python
"""
Convert a series of VTK files into a single, transient VTKHDF file.
This script is designed to be run with ParaView's pvpython executable.
"""

from paraview.simple import *
import os
import glob

def convert_vtk_series_to_vtkhdf(file_pattern, output_file, compression_level=4):
    """
    Convert a series of VTK files into a single VTKHDF file.

    Args:
        file_pattern (str): Glob pattern matching your VTK files (e.g., "path/to/anim_*.vtk").
        output_file (str): Output filename (must end with .vtkhdf).
        compression_level (int): Compression level (0-9) for the HDF5 file.
                                 4 provides a good balance between size and speed.
    """
    # Get list of files sorted alphabetically
    vtk_files = sorted(glob.glob(file_pattern))

    if not vtk_files:
        print(f"ERROR: No files found matching pattern '{file_pattern}'")
        return

    print(f"Found {len(vtk_files)} VTK files to convert.")

    # Create a reader for the file series
    # Using LegacyVTKReader for .vtk files
    print("Loading file series...")
    reader = LegacyVTKReader(FileNames=vtk_files)

    # Save the data as a VTKHDF file
    print(f"Saving to {output_file}...")
    SaveData(
        output_file,
        proxy=reader,
        WriteAllTimeSteps=1,      # Save all time steps into one file
        CompressionLevel=compression_level
    )
    print("Conversion complete!")


if __name__ == "__main__":
    # --- CONFIGURATION ---
    # Update these paths for your specific case
    INPUT_FILE_PATTERN = "D:/rad/Bumper_Beam_AP_meshed*.vtk"  # e.g., Cell_Phone_DropA001.vtk, A002.vtk, etc.
    OUTPUT_FILE = "D:/rad/Bumper_Beam_AP_meshed.vtkhdf"

    convert_vtk_series_to_vtkhdf(INPUT_FILE_PATTERN, OUTPUT_FILE)
NOTE: 52 records were read from file 'c:\temp\py_pgmx.py'
      The minimum record length was 80
      The maximum record length was 109
NOTE: 52 records were written to file 'c:\temp\py_pgm.py'
      The minimum record length was 80
      The maximum record length was 109
NOTE: The data step took :
      real time : 0.015
      cpu time  : 0.000



NOTE: The infile rut is:
      Unnamed Pipe Access Device,
      Process=C:\Progra~1\ParaView-6.1.0-Windows-Python3.12-msvc2017-AMD64\bin\pvpython.exe c:/temp/py_pgm.py 2> c:/temp/py_pgm.log,
      Lrecl=32767, Recfm=V

Found 101 VTK files to convert.
Loading file series...
Saving to D:/rad/Bumper_Beam_AP_meshed.vtkhdf...
Conversion complete!
NOTE: 4 records were written to file PRINT

NOTE: 4 records were read from file rut
      The minimum record length was 20
      The maximum record length was 48
NOTE: The data step took :
      real time : 2:20.840
      cpu time  : 0:00.031



NOTE: The infile 'c:\temp\py_pgm.log' is:
      Filename='c:\temp\py_pgm.log',
      Owner Name=SLC\suzie,
      File size (bytes)=0,
      Create Time=11:45:37 May 12 2026,
      Last Accessed=16:41:57 May 25 2026,
      Last Modified=16:41:57 May 25 2026,
      Lrecl=32767, Recfm=V

NOTE: No records were read from file 'c:\temp\py_pgm.log'
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.000


ERROR: Error printed on page 1

NOTE: Submitted statements took :
      real time : 2:21.031
      cpu time  : 0:00.156


/*___         _   _       _  __   _
 ( _ ) __   _| |_| | ____| |/ _| | |_ ___     ___ _____   __
 / _ \ \ \ / / __| |/ / _` | |_  | __/ _ \   / __/ __\ \ / /
| (_) | \ V /| |_|   < (_| |  _| | || (_) | | (__\__ \\ V /
 \___/   \_/  \__|_|\_\__,_|_|    \__\___/   \___|___/ \_/

*/

/**************************************************************************************************************************/
/* Create CSVs                                                                                                            */
/*                                                                                                                        */
/* d:/rad                                                                                                                 */
/*   global_energy_data.csv                                                                                               */
/*   cell_data.csv                                                                                                        */
/*                                                                                                                        */
/**************************************************************************************************************************/

%slc_pvpybegin;
cards4;
#!/usr/bin/env python
"""
Extract ALL stress, strain, and energy data from VTKHDF.
Run with: pvpython this_script.py
"""

from paraview.simple import *
from paraview import servermanager
import csv
import os

# ------------------------------------------------------------
# CONFIGURATION
# ------------------------------------------------------------
VTKHDF_FILE = "D:/rad/Bumper_Beam_AP_meshed.vtkhdf"
OUTPUT_CSV = "D:/rad/simulation_data_complete.csv"

# ------------------------------------------------------------
# LOAD THE DATA
# ------------------------------------------------------------
print(f"Loading file: {VTKHDF_FILE}")
source = OpenDataFile(VTKHDF_FILE)
source.UpdatePipeline()

# ------------------------------------------------------------
# CHECK WHAT DATA IS AVAILABLE
# ------------------------------------------------------------
print("\n--- Available Data Arrays ---")
print(f"Point Data: {list(source.PointData.keys())}")
print(f"Cell Data: {list(source.CellData.keys())}")

# Get timesteps
timesteps = source.TimestepValues
print(f"\nNumber of timesteps: {len(timesteps)}")

# ------------------------------------------------------------
# CREATE AN INTEGRATE VARIABLES FILTER FOR GLOBAL TOTALS
# ------------------------------------------------------------
print("\nCalculating global integrated quantities...")
integrate = IntegrateVariables(Input=source)

# ------------------------------------------------------------
# METHOD 1: Export global integrated data (energy totals)
# ------------------------------------------------------------
print("\nSaving global integrated data...")
output_global = "D:/rad/global_energy_data.csv"
SaveData(output_global, proxy=integrate, WriteTimeSteps=1, Precision=12)
print(f"Global energy data saved to: {output_global}")

# ------------------------------------------------------------
# METHOD 2: Extract data for a specific point/region
# ------------------------------------------------------------
# If you want data for a specific point, use a threshold or clip filter
# For example, to get data for the entire model, you can export cell data

print("\nSaving cell data (if available)...")
if len(source.CellData.keys()) > 0:
    output_cell = "D:/rad/cell_data.csv"
    SaveData(output_cell, proxy=source, WriteTimeSteps=1,
             FieldAssociation='Cell Data', Precision=12)
    print(f"Cell data saved to: {output_cell}")

# ------------------------------------------------------------
# METHOD 3: Manual extraction of specific arrays
# ------------------------------------------------------------
print("\nExtracting specific arrays manually...")

# Get a list of arrays you want to extract
arrays_of_interest = ['GPS_SIGXX', 'GPS_SIGXY', 'GPS_SIGXZ', 'GPS_SIGYY',
                      'GPS_SIGZY', 'GPS_SIGZZ']

# Check which arrays actually exist
available_arrays = [arr for arr in arrays_of_interest if arr in source.PointData.keys()]

if available_arrays:
    # Create a calculator to extract just these arrays
    calculator = Calculator(Input=source)
    calculator.ResultArrayName = 'Extracted_Data'
    calculator.Function = ' '.join(available_arrays)

    output_extracted = "D:/rad/extracted_stress_data.csv"
    SaveData(output_extracted, proxy=calculator, WriteTimeSteps=1, Precision=12)
    print(f"Extracted stress data saved to: {output_extracted}")
else:
    print("No requested arrays found. Available arrays are:")
    print(f"  {list(source.PointData.keys())}")

print("\n--- Summary ---")
print(f"CSV files created in D:/rad/")
print("  - global_energy_data.csv: Total internal/kinetic energy over time")
print("  - cell_data.csv: Data for all cells (if available)")
print("  - extracted_stress_data.csv: Specific stress components")

# Verify files
for f in ['global_energy_data.csv', 'cell_data.csv', 'extracted_stress_data.csv']:
    path = f"D:/rad/{f}"
    if os.path.exists(path) and os.path.getsize(path) > 0:
        size_kb = os.path.getsize(path) / 1024
        print(f"  âœ“ {f} ({size_kb:.2f} KB)")
    elif os.path.exists(path):
        print(f"  âœ— {f} (0 bytes - no data)")
    else:
        print(f"  âœ— {f} (not created)")
;;;;
%slc_pvpyend;

Altair SLC
Loading file: D:/rad/Bumper_Beam_AP_meshed.vtkhdf

--- Available Data Arrays ---
Point Data: ['NODE_ID']
Cell Data: ['2DELEM_Plastic_Strain', '2DELEM_Strain_(layer__1)_', '2DELEM_Strain_(layer__2)_',
 '2DELEM_Strain_(layer__3)_', '2DELEM_Strain_(layer__4)_', '2DELEM_Strain_(layer__5)_',
 '2DELEM_Strain_(lower)', '2DELEM_Strain_(upper)', '2DELEM_Stress_(layer__
1)_', '2DELEM_Stress_(layer__2)_', '2DELEM_Stress_(layer__3)_', '2DELEM_Stress_(layer__4)_',
 '2DELEM_Stress_(layer__5)_', '2DELEM_Stress_(lower)', '2DELEM_Stress_(upper)',
 '2DELEM_Von_Mises', 'ELEMENT_ID', 'EROSION_STATUS', 'PART_ID']

Number of timesteps: 101

Calculating global integrated quantities...

Saving global integrated data...
Global energy data saved to: D:/rad/global_energy_data.csv

Saving cell data (if available)...
Cell data saved to: D:/rad/cell_data.csv

Extracting specific arrays manually...
No requested arrays found. Available arrays are:
  ['NODE_ID']

--- Summary ---
CSV files created in D:/rad/
  - global_energy_data.csv: Total internal/kinetic energy over time
  - cell_data.csv: Data for all cells (if available)
  - extracted_stress_data.csv: Specific stress components
  Ã¢Å“â€œ global_energy_data.csv (6.01 KB)
  Ã¢Å“â€œ cell_data.csv (1524903.14 KB)
  Ã¢Å“â€” extracted_stress_data.csv (not created)

/**************************************************************************************************************************/
/* Altair SLC                                                                                                             */
/* Loading file: D:/rad/Bumper_Beam_AP_meshed.vtkhdf                                                                      */
/*                                                                                                                        */
/* --- Available Data Arrays ---                                                                                          */
/* Point Data: ['NODE_ID']                                                                                                */
/* Cell Data: ['2DELEM_Plastic_Strain', '2DELEM_Strain_(layer__1)_', '2DELEM_Strain_(layer__2)_',                         */
/*  '2DELEM_Strain_(layer__3)_', '2DELEM_Strain_(layer__4)_', '2DELEM_Strain_(layer__5)_',                                */
/*  '2DELEM_Strain_(lower)', '2DELEM_Strain_(upper)', '2DELEM_Stress_(layer__                                             */
/* 1)_', '2DELEM_Stress_(layer__2)_', '2DELEM_Stress_(layer__3)_', '2DELEM_Stress_(layer__4)_',                           */
/*  '2DELEM_Stress_(layer__5)_', '2DELEM_Stress_(lower)', '2DELEM_Stress_(upper)',                                        */
/*  '2DELEM_Von_Mises', 'ELEMENT_ID', 'EROSION_STATUS', 'PART_ID']                                                        */
/*                                                                                                                        */
/* Number of timesteps: 101                                                                                               */
/*                                                                                                                        */
/* Calculating global integrated quantities...                                                                            */
/*                                                                                                                        */
/* Saving global integrated data...                                                                                       */
/* Global energy data saved to: D:/rad/global_energy_data.csv                                                             */
/*                                                                                                                        */
/* Saving cell data (if available)...                                                                                     */
/* Cell data saved to: D:/rad/cell_data.csv                                                                               */
/*                                                                                                                        */
/* Extracting specific arrays manually...                                                                                 */
/* No requested arrays found. Available arrays are:                                                                       */
/*   ['NODE_ID']                                                                                                          */
/*                                                                                                                        */
/* --- Summary ---                                                                                                        */
/* CSV files created in D:/rad/                                                                                           */
/*   - global_energy_data.csv: Total internal/kinetic energy over time                                                    */
/*   - cell_data.csv: Data for all cells (if available)                                                                   */
/*   - extracted_stress_data.csv: Specific stress components                                                              */
/*   Ã¢Å“â€œ global_energy_data.csv (6.01 KB)                                                                             */
/*   Ã¢Å“â€œ cell_data.csv (1524903.14 KB)                                                                                */
/*   Ã¢Å“â€” extracted_stress_data.csv (not created)                                                                      */
/* Data extraction complete!                                                                                              */
/**************************************************************************************************************************/

/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

1                                          Altair SLC            18:37 Monday, May 25, 2026

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿ods _all_ close;
           ^
ERROR: Expected a statement keyword : found "?"

NOTE: AUTOEXEC processing completed

1          %slc_pvpybegin;
The file c:/temp/py_pgm.py does not exist
2         cards4;

NOTE: The file 'c:\temp\py_pgmx.py' is:
      Filename='c:\temp\py_pgmx.py',
      Owner Name=SLC\suzie,
      File size (bytes)=0,
      Create Time=13:21:25 Jan 12 2026,
      Last Accessed=18:37:25 May 25 2026,
      Last Modified=18:37:25 May 25 2026,
      Lrecl=32767, Recfm=V

NOTE: 103 records were written to file 'c:\temp\py_pgmx.py'
      The minimum record length was 80
      The maximum record length was 88
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.015


3         #!/usr/bin/env python
4         """
5         Extract ALL stress, strain, and energy data from VTKHDF.
6         Run with: pvpython this_script.py
7         """
8
9         from paraview.simple import *
10        from paraview import servermanager
11        import csv
12        import os
13
14        # ------------------------------------------------------------
15        # CONFIGURATION
16        # ------------------------------------------------------------
17        VTKHDF_FILE = "D:/rad/Bumper_Beam_AP_meshed.vtkhdf"
18        OUTPUT_CSV = "D:/rad/simulation_data_complete.csv"
19
20        # ------------------------------------------------------------
21        # LOAD THE DATA
22        # ------------------------------------------------------------
23        print(f"Loading file: {VTKHDF_FILE}")
24        source = OpenDataFile(VTKHDF_FILE)
25        source.UpdatePipeline()
26
27        # ------------------------------------------------------------
28        # CHECK WHAT DATA IS AVAILABLE
29        # ------------------------------------------------------------
30        print("\n--- Available Data Arrays ---")
31        print(f"Point Data: {list(source.PointData.keys())}")
32        print(f"Cell Data: {list(source.CellData.keys())}")
33
34        # Get timesteps
35        timesteps = source.TimestepValues
36        print(f"\nNumber of timesteps: {len(timesteps)}")
37
38        # ------------------------------------------------------------
39        # CREATE AN INTEGRATE VARIABLES FILTER FOR GLOBAL TOTALS
40        # ------------------------------------------------------------
41        print("\nCalculating global integrated quantities...")
42        integrate = IntegrateVariables(Input=source)
43
44        # ------------------------------------------------------------
45        # METHOD 1: Export global integrated data (energy totals)
46        # ------------------------------------------------------------
47        print("\nSaving global integrated data...")
48        output_global = "D:/rad/global_energy_data.csv"
49        SaveData(output_global, proxy=integrate, WriteTimeSteps=1, Precision=12)
50        print(f"Global energy data saved to: {output_global}")
51
52        # ------------------------------------------------------------
53        # METHOD 2: Extract data for a specific point/region
54        # ------------------------------------------------------------
55        # If you want data for a specific point, use a threshold or clip filter
56        # For example, to get data for the entire model, you can export cell data
57
58        print("\nSaving cell data (if available)...")
59        if len(source.CellData.keys()) > 0:
60            output_cell = "D:/rad/cell_data.csv"
61            SaveData(output_cell, proxy=source, WriteTimeSteps=1,
62                     FieldAssociation='Cell Data', Precision=12)
63            print(f"Cell data saved to: {output_cell}")
64
65        # ------------------------------------------------------------
66        # METHOD 3: Manual extraction of specific arrays
67        # ------------------------------------------------------------
68        print("\nExtracting specific arrays manually...")
69
70        # Get a list of arrays you want to extract
71        arrays_of_interest = ['GPS_SIGXX', 'GPS_SIGXY', 'GPS_SIGXZ', 'GPS_SIGYY',
72                              'GPS_SIGZY', 'GPS_SIGZZ']
73
74        # Check which arrays actually exist
75        available_arrays = [arr for arr in arrays_of_interest if arr in source.PointData.keys()]
76
77        if available_arrays:
78            # Create a calculator to extract just these arrays
79            calculator = Calculator(Input=source)
80            calculator.ResultArrayName = 'Extracted_Data'
81            calculator.Function = ' '.join(available_arrays)
82
83            output_extracted = "D:/rad/extracted_stress_data.csv"
84            SaveData(output_extracted, proxy=calculator, WriteTimeSteps=1, Precision=12)
85            print(f"Extracted stress data saved to: {output_extracted}")
86        else:
87            print("No requested arrays found. Available arrays are:")
88            print(f"  {list(source.PointData.keys())}")
89
90        print("\n--- Summary ---")
91        print(f"CSV files created in D:/rad/")
92        print("  - global_energy_data.csv: Total internal/kinetic energy over time")
93        print("  - cell_data.csv: Data for all cells (if available)")
94        print("  - extracted_stress_data.csv: Specific stress components")
95
96        # Verify files
97        for f in ['global_energy_data.csv', 'cell_data.csv', 'extracted_stress_data.csv']:
98            path = f"D:/rad/{f}"
99            if os.path.exists(path) and os.path.getsize(path) > 0:
100               size_kb = os.path.getsize(path) / 1024
101               print(f"  Ã¢Å“â€œ {f} ({size_kb:.2f} KB)")
102           elif os.path.exists(path):
103               print(f"  Ã¢Å“â€” {f} (0 bytes - no data)")
104           else:
105               print(f"  Ã¢Å“â€” {f} (not created)")
106       ;;;;
107       %slc_pvpyend;

NOTE: The infile 'c:\temp\py_pgmx.py' is:
      Filename='c:\temp\py_pgmx.py',
      Owner Name=SLC\suzie,
      File size (bytes)=8456,
      Create Time=13:21:25 Jan 12 2026,
      Last Accessed=18:37:25 May 25 2026,
      Last Modified=18:37:25 May 25 2026,
      Lrecl=32767, Recfm=V

NOTE: The file 'c:\temp\py_pgm.py' is:
      Filename='c:\temp\py_pgm.py',
      Owner Name=SLC\suzie,
      File size (bytes)=0,
      Create Time=16:38:15 May 12 2026,
      Last Accessed=18:37:25 May 25 2026,
      Last Modified=18:37:25 May 25 2026,
      Lrecl=32767, Recfm=V

#!/usr/bin/env python
"""
Extract ALL stress, strain, and energy data from VTKHDF.
Run with: pvpython this_script.py
"""

from paraview.simple import *
from paraview import servermanager
import csv
import os

# ------------------------------------------------------------
# CONFIGURATION
# ------------------------------------------------------------
VTKHDF_FILE = "D:/rad/Bumper_Beam_AP_meshed.vtkhdf"
OUTPUT_CSV = "D:/rad/simulation_data_complete.csv"

# ------------------------------------------------------------
# LOAD THE DATA
# ------------------------------------------------------------
print(f"Loading file: {VTKHDF_FILE}")
source = OpenDataFile(VTKHDF_FILE)
source.UpdatePipeline()

# ------------------------------------------------------------
# CHECK WHAT DATA IS AVAILABLE
# ------------------------------------------------------------
print("\n--- Available Data Arrays ---")
print(f"Point Data: {list(source.PointData.keys())}")
print(f"Cell Data: {list(source.CellData.keys())}")

# Get timesteps
timesteps = source.TimestepValues
print(f"\nNumber of timesteps: {len(timesteps)}")

# ------------------------------------------------------------
# CREATE AN INTEGRATE VARIABLES FILTER FOR GLOBAL TOTALS
# ------------------------------------------------------------
print("\nCalculating global integrated quantities...")
integrate = IntegrateVariables(Input=source)

# ------------------------------------------------------------
# METHOD 1: Export global integrated data (energy totals)
# ------------------------------------------------------------
print("\nSaving global integrated data...")
output_global = "D:/rad/global_energy_data.csv"
SaveData(output_global, proxy=integrate, WriteTimeSteps=1, Precision=12)
print(f"Global energy data saved to: {output_global}")

# ------------------------------------------------------------
# METHOD 2: Extract data for a specific point/region
# ------------------------------------------------------------
# If you want data for a specific point, use a threshold or clip filter
# For example, to get data for the entire model, you can export cell data

print("\nSaving cell data (if available)...")
if len(source.CellData.keys()) > 0:
    output_cell = "D:/rad/cell_data.csv"
    SaveData(output_cell, proxy=source, WriteTimeSteps=1,
             FieldAssociation='Cell Data', Precision=12)
    print(f"Cell data saved to: {output_cell}")

# ------------------------------------------------------------
# METHOD 3: Manual extraction of specific arrays
# ------------------------------------------------------------
print("\nExtracting specific arrays manually...")

# Get a list of arrays you want to extract
arrays_of_interest = ['GPS_SIGXX', 'GPS_SIGXY', 'GPS_SIGXZ', 'GPS_SIGYY',
                      'GPS_SIGZY', 'GPS_SIGZZ']

# Check which arrays actually exist
available_arrays = [arr for arr in arrays_of_interest if arr in source.PointData.keys()]

if available_arrays:
    # Create a calculator to extract just these arrays
    calculator = Calculator(Input=source)
    calculator.ResultArrayName = 'Extracted_Data'
    calculator.Function = ' '.join(available_arrays)

    output_extracted = "D:/rad/extracted_stress_data.csv"
    SaveData(output_extracted, proxy=calculator, WriteTimeSteps=1, Precision=12)
    print(f"Extracted stress data saved to: {output_extracted}")
else:
    print("No requested arrays found. Available arrays are:")
    print(f"  {list(source.PointData.keys())}")

print("\n--- Summary ---")
print(f"CSV files created in D:/rad/")
print("  - global_energy_data.csv: Total internal/kinetic energy over time")
print("  - cell_data.csv: Data for all cells (if available)")
print("  - extracted_stress_data.csv: Specific stress components")

# Verify files
for f in ['global_energy_data.csv', 'cell_data.csv', 'extracted_stress_data.csv']:
    path = f"D:/rad/{f}"
    if os.path.exists(path) and os.path.getsize(path) > 0:
        size_kb = os.path.getsize(path) / 1024
        print(f"  Ã¢Å“â€œ {f} ({size_kb:.2f} KB)")
    elif os.path.exists(path):
        print(f"  Ã¢Å“â€” {f} (0 bytes - no data)")
    else:
        print(f"  Ã¢Å“â€” {f} (not created)")
NOTE: 103 records were read from file 'c:\temp\py_pgmx.py'
      The minimum record length was 80
      The maximum record length was 88
NOTE: 103 records were written to file 'c:\temp\py_pgm.py'
      The minimum record length was 80
      The maximum record length was 88
NOTE: The data step took :
      real time : 0.015
      cpu time  : 0.015



NOTE: The infile rut is:
      Unnamed Pipe Access Device,
      Process=C:\Progra~1\ParaView-6.1.0-Windows-Python3.12-msvc2017-AMD64\bin\pvpython.exe c:/temp/py_pgm.py 2> c:/temp/py_pgm.log,
      Lrecl=32767, Recfm=V

Loading file: D:/rad/Bumper_Beam_AP_meshed.vtkhdf

--- Available Data Arrays ---
Point Data: ['NODE_ID']
Cell Data: ['2DELEM_Plastic_Strain', '2DELEM_Strain_(layer__1)_', '2DELEM_Strain_(layer__2)_',
 '2DELEM_Strain_(layer__3)_', '2DELEM_Strain_(layer__4)_', '2DELEM_Strain_(layer__5)_',
 '2DELEM_Strain_(lower)', '2DELEM_Strain_(upper)', '2DELEM_Stress_(layer__
1)_', '2DELEM_Stress_(layer__2)_', '2DELEM_Stress_(layer__3)_', '2DELEM_Stress_(layer__4)_',
 '2DELEM_Stress_(layer__5)_', '2DELEM_Stress_(lower)', '2DELEM_Stress_(upper)',
 '2DELEM_Von_Mises', 'ELEMENT_ID', 'EROSION_STATUS', 'PART_ID']

Number of timesteps: 101

Calculating global integrated quantities...

Saving global integrated data...
Global energy data saved to: D:/rad/global_energy_data.csv

Saving cell data (if available)...
Cell data saved to: D:/rad/cell_data.csv

Extracting specific arrays manually...
No requested arrays found. Available arrays are:
  ['NODE_ID']

--- Summary ---
CSV files created in D:/rad/
  - global_energy_data.csv: Total internal/kinetic energy over time
  - cell_data.csv: Data for all cells (if available)
  - extracted_stress_data.csv: Specific stress components
   global_energy_data.csv (6.01 KB)
   cell_data.csv (1524903.14 KB)
   extracted_stress_data.csv (not created)
NOTE: 29 records were written to file PRINT

NOTE: 28 records were read from file rut
      The minimum record length was 0
      The maximum record length was 489
NOTE: The data step took :
      real time : 3:31.921
      cpu time  : 0:00.000



NOTE: The infile 'c:\temp\py_pgm.log' is:
      Filename='c:\temp\py_pgm.log',
      Owner Name=SLC\suzie,
      File size (bytes)=0,
      Create Time=11:45:37 May 12 2026,
      Last Accessed=18:37:25 May 25 2026,
      Last Modified=18:37:25 May 25 2026,
      Lrecl=32767, Recfm=V

NOTE: No records were read from file 'c:\temp\py_pgm.log'
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.000


ERROR: Error printed on page 1

NOTE: Submitted statements took :
      real time : 3:32.128
      cpu time  : 0:00.109


/*___            _ _       _       _
 / _ \   ___ ___| | |   __| | __ _| |_ __ _
| (_) | / __/ _ \ | |  / _` |/ _` | __/ _` |
 \__, || (_|  __/ | | | (_| | (_| | || (_| |
   /_/  \___\___|_|_|  \__,_|\__,_|\__\__,_|

*/

/**************************************************************************************************************************/
/*                                                                                                                        */
/* These variables are the strain tensor components at specific                                                           */
/* integration points within each 3D brick element in your cell phone drop simulation.                                    */
/*                                                                                                                        */
/* 3D Element        Part            Meaning                                                                              */
/*                                                                                                                        */
/* 1st Columnm      Dim2_DELEM        2D Element (shell)                                                                  */
/*                  Strain            Strain (as opposed to Strs for Stress)                                              */
/*                  Intg_Point        Integration point (Gauss point within the element)                                  */
/*                  111               Integration point location indices                                                  */
/*                  :0                Tensor component index                                                              */
/*                  ...                                                                                                   */
/*                  ...                                                                                                   */
/* 149th Column     Dim2_DELEM        2D Element (shell)                                                                  */
/*                  Stress            Strain (as opposed to Strs for Stress)                                              */
/*                  Intg_Point        Integration point (Gauss point within the element)                                  */
/*                  222               Integration point location indices                                                  */
/*                  :8                Tensor component index                                                              */
/**************************************************************************************************************************/


data WORKx.CELL_DATA    ;
infile "d:/rad/cell_data.csv" delimiter = ',' MISSOVER DSD lrecl=32756 firstobs=2 ;

LABEL
    ELEMENT_ID = "Element identification number"
    EROSION_STATUS = "Element erosion flag (0=active, 1=eroded)"
    PART_ID = "Part identification number"
    CELL_TYPE = "Element cell type (e.g., hex, tet, wedge)"
    DIM3_ELEM_PLASTIC_STRAIN = "Plastic strain (3D element)"
    DIM3_ELEM_STRAIN_LAYER_1_0 = "Element strain - Layer 1, integration point 0"
    DIM3_ELEM_STRAIN_LAYER_1_1 = "Element strain - Layer 1, integration point 1"
    DIM3_ELEM_STRAIN_LAYER_1_2 = "Element strain - Layer 1, integration point 2"
    DIM3_ELEM_STRAIN_LAYER_1_3 = "Element strain - Layer 1, integration point 3"
    DIM3_ELEM_STRAIN_LAYER_1_4 = "Element strain - Layer 1, integration point 4"
    DIM3_ELEM_STRAIN_LAYER_1_5 = "Element strain - Layer 1, integration point 5"
    DIM3_ELEM_STRAIN_LAYER_1_6 = "Element strain - Layer 1, integration point 6"
    DIM3_ELEM_STRAIN_LAYER_1_7 = "Element strain - Layer 1, integration point 7"
    DIM3_ELEM_STRAIN_LAYER_1_8 = "Element strain - Layer 1, integration point 8"
    DIM3_ELEM_VON_MISES = "Von Mises stress (3D element)"
;
input
  DIM3_ELEM_Plastic_Strain
  DIM3_ELEM_Strain_layer_1_0
  DIM3_ELEM_Strain_layer_1_1
  DIM3_ELEM_Strain_layer_1_2
  DIM3_ELEM_Strain_layer_1_3
  DIM3_ELEM_Strain_layer_1_4
  DIM3_ELEM_Strain_layer_1_5
  DIM3_ELEM_Strain_layer_1_6
  DIM3_ELEM_Strain_layer_1_7
  DIM3_ELEM_Strain_layer_1_8
  DIM3_ELEM_Strain_layer_2_0
  DIM3_ELEM_Strain_layer_2_1
  DIM3_ELEM_Strain_layer_2_2
  DIM3_ELEM_Strain_layer_2_3
  DIM3_ELEM_Strain_layer_2_4
  DIM3_ELEM_Strain_layer_2_5
  DIM3_ELEM_Strain_layer_2_6
  DIM3_ELEM_Strain_layer_2_7
  DIM3_ELEM_Strain_layer_2_8
  DIM3_ELEM_Strain_layer_3_0
  DIM3_ELEM_Strain_layer_3_1
  DIM3_ELEM_Strain_layer_3_2
  DIM3_ELEM_Strain_layer_3_3
  DIM3_ELEM_Strain_layer_3_4
  DIM3_ELEM_Strain_layer_3_5
  DIM3_ELEM_Strain_layer_3_6
  DIM3_ELEM_Strain_layer_3_7
  DIM3_ELEM_Strain_layer_3_8
  DIM3_ELEM_Strain_layer_4_0
  DIM3_ELEM_Strain_layer_4_1
  DIM3_ELEM_Strain_layer_4_2
  DIM3_ELEM_Strain_layer_4_3
  DIM3_ELEM_Strain_layer_4_4
  DIM3_ELEM_Strain_layer_4_5
  DIM3_ELEM_Strain_layer_4_6
  DIM3_ELEM_Strain_layer_4_7
  DIM3_ELEM_Strain_layer_4_8
  DIM3_ELEM_Strain_layer_5_0
  DIM3_ELEM_Strain_layer_5_1
  DIM3_ELEM_Strain_layer_5_2
  DIM3_ELEM_Strain_layer_5_3
  DIM3_ELEM_Strain_layer_5_4
  DIM3_ELEM_Strain_layer_5_5
  DIM3_ELEM_Strain_layer_5_6
  DIM3_ELEM_Strain_layer_5_7
  DIM3_ELEM_Strain_layer_5_8
  DIM3_ELEM_Strain_lower_0
  DIM3_ELEM_Strain_lower_1
  DIM3_ELEM_Strain_lower_2
  DIM3_ELEM_Strain_lower_3
  DIM3_ELEM_Strain_lower_4
  DIM3_ELEM_Strain_lower_5
  DIM3_ELEM_Strain_lower_6
  DIM3_ELEM_Strain_lower_7
  DIM3_ELEM_Strain_lower_8
  DIM3_ELEM_Strain_upper_0
  DIM3_ELEM_Strain_upper_1
  DIM3_ELEM_Strain_upper_2
  DIM3_ELEM_Strain_upper_3
  DIM3_ELEM_Strain_upper_4
  DIM3_ELEM_Strain_upper_5
  DIM3_ELEM_Strain_upper_6
  DIM3_ELEM_Strain_upper_7
  DIM3_ELEM_Strain_upper_8
  DIM3_ELEM_Stress_layer_1_0
  DIM3_ELEM_Stress_layer_1_1
  DIM3_ELEM_Stress_layer_1_2
  DIM3_ELEM_Stress_layer_1_3
  DIM3_ELEM_Stress_layer_1_4
  DIM3_ELEM_Stress_layer_1_5
  DIM3_ELEM_Stress_layer_1_6
  DIM3_ELEM_Stress_layer_1_7
  DIM3_ELEM_Stress_layer_1_8
  DIM3_ELEM_Stress_layer_2_0
  DIM3_ELEM_Stress_layer_2_1
  DIM3_ELEM_Stress_layer_2_2
  DIM3_ELEM_Stress_layer_2_3
  DIM3_ELEM_Stress_layer_2_4
  DIM3_ELEM_Stress_layer_2_5
  DIM3_ELEM_Stress_layer_2_6
  DIM3_ELEM_Stress_layer_2_7
  DIM3_ELEM_Stress_layer_2_8
  DIM3_ELEM_Stress_layer_3_0
  DIM3_ELEM_Stress_layer_3_1
  DIM3_ELEM_Stress_layer_3_2
  DIM3_ELEM_Stress_layer_3_3
  DIM3_ELEM_Stress_layer_3_4
  DIM3_ELEM_Stress_layer_3_5
  DIM3_ELEM_Stress_layer_3_6
  DIM3_ELEM_Stress_layer_3_7
  DIM3_ELEM_Stress_layer_3_8
  DIM3_ELEM_Stress_layer_4_0
  DIM3_ELEM_Stress_layer_4_1
  DIM3_ELEM_Stress_layer_4_2
  DIM3_ELEM_Stress_layer_4_3
  DIM3_ELEM_Stress_layer_4_4
  DIM3_ELEM_Stress_layer_4_5
  DIM3_ELEM_Stress_layer_4_6
  DIM3_ELEM_Stress_layer_4_7
  DIM3_ELEM_Stress_layer_4_8
  DIM3_ELEM_Stress_layer_5_0
  DIM3_ELEM_Stress_layer_5_1
  DIM3_ELEM_Stress_layer_5_2
  DIM3_ELEM_Stress_layer_5_3
  DIM3_ELEM_Stress_layer_5_4
  DIM3_ELEM_Stress_layer_5_5
  DIM3_ELEM_Stress_layer_5_6
  DIM3_ELEM_Stress_layer_5_7
  DIM3_ELEM_Stress_layer_5_8
  DIM3_ELEM_Stress_lower_0
  DIM3_ELEM_Stress_lower_1
  DIM3_ELEM_Stress_lower_2
  DIM3_ELEM_Stress_lower_3
  DIM3_ELEM_Stress_lower_4
  DIM3_ELEM_Stress_lower_5
  DIM3_ELEM_Stress_lower_6
  DIM3_ELEM_Stress_lower_7
  DIM3_ELEM_Stress_lower_8
  DIM3_ELEM_Stress_upper_0
  DIM3_ELEM_Stress_upper_1
  DIM3_ELEM_Stress_upper_2
  DIM3_ELEM_Stress_upper_3
  DIM3_ELEM_Stress_upper_4
  DIM3_ELEM_Stress_upper_5
  DIM3_ELEM_Stress_upper_6
  DIM3_ELEM_Stress_upper_7
  DIM3_ELEM_Stress_upper_8
  DIM3_ELEM_Von_Mises
  ELEMENT_ID
  EROSION_STATUS
  PART_ID
  Cell_Type
  empty best32.
;
run;

proc means data=WORKX.CELL_data n mean std min max;
run;

The MEANS Procedure

Variable                            N            Mean         Std Dev         Minimum         Maximum
-----------------------------------------------------------------------------------------------------
DIM3_ELEM_PLASTIC_STRAIN      1402789       0.0019433       0.0118552               0       0.3347460
DIM3_ELEM_STRAIN_LAYER_1_0    1402789    -0.000349714       0.0116653      -0.4625930       0.2393350
DIM3_ELEM_STRAIN_LAYER_1_1    1402789    -0.000063310       0.0043787      -0.0866327       0.0662850
DIM3_ELEM_STRAIN_LAYER_1_2    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_1_3    1402789    -0.000063310       0.0043787      -0.0866327       0.0662850
DIM3_ELEM_STRAIN_LAYER_1_4    1402789    -0.000347787       0.0116767      -0.4644540       0.2390880
DIM3_ELEM_STRAIN_LAYER_1_5    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_1_6    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_1_7    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_1_8    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_2_0    1402789    -0.000353972       0.0090021      -0.3846790       0.1467110
DIM3_ELEM_STRAIN_LAYER_2_1    1402789    -0.000036312       0.0040832      -0.0767474       0.0763734
DIM3_ELEM_STRAIN_LAYER_2_2    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_2_3    1402789    -0.000036312       0.0040832      -0.0767474       0.0763734
DIM3_ELEM_STRAIN_LAYER_2_4    1402789    -0.000351544       0.0090074      -0.3859000       0.1462850
DIM3_ELEM_STRAIN_LAYER_2_5    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_2_6    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_2_7    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_2_8    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_3_0    1402789    -0.000358231       0.0075764      -0.3067650       0.1164660
DIM3_ELEM_STRAIN_LAYER_3_1    1402789    -9.313727E-6       0.0043793      -0.1088530       0.1020260
DIM3_ELEM_STRAIN_LAYER_3_2    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_3_3    1402789    -9.313727E-6       0.0043793      -0.1088530       0.1020260
DIM3_ELEM_STRAIN_LAYER_3_4    1402789    -0.000355300       0.0075752      -0.3073470       0.1163190
DIM3_ELEM_STRAIN_LAYER_3_5    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_3_6    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_3_7    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_3_8    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_4_0    1402789    -0.000362489       0.0080729      -0.2396190       0.1604290
DIM3_ELEM_STRAIN_LAYER_4_1    1402789     0.000017685       0.0051662      -0.1416350       0.1324560
DIM3_ELEM_STRAIN_LAYER_4_2    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_4_3    1402789     0.000017685       0.0051662      -0.1416350       0.1324560
DIM3_ELEM_STRAIN_LAYER_4_4    1402789    -0.000359057       0.0080682      -0.2396140       0.1603100
DIM3_ELEM_STRAIN_LAYER_4_5    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_4_6    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_4_7    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_4_8    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_5_0    1402789    -0.000366748       0.0102150      -0.2443030       0.2325350
DIM3_ELEM_STRAIN_LAYER_5_1    1402789     0.000044683       0.0062616      -0.1744170       0.1704110
DIM3_ELEM_STRAIN_LAYER_5_2    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_5_3    1402789     0.000044683       0.0062616      -0.1744170       0.1704110
DIM3_ELEM_STRAIN_LAYER_5_4    1402789    -0.000362813       0.0102112      -0.2439510       0.2322900
DIM3_ELEM_STRAIN_LAYER_5_5    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_5_6    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_5_7    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LAYER_5_8    1402789               0               0               0               0
DIM3_ELEM_STRAIN_LOWER_0      1402789    -0.000347585       0.0132430      -0.5015500       0.2881050
DIM3_ELEM_STRAIN_LOWER_1      1402789    -0.000076809       0.0047223      -0.0921685       0.0733728
DIM3_ELEM_STRAIN_LOWER_2      1402789               0               0               0               0
DIM3_ELEM_STRAIN_LOWER_3      1402789    -0.000076809       0.0047223      -0.0921685       0.0733728
DIM3_ELEM_STRAIN_LOWER_4      1402789    -0.000345909       0.0132571      -0.5037310       0.2885280
DIM3_ELEM_STRAIN_LOWER_5      1402789               0               0               0               0
DIM3_ELEM_STRAIN_LOWER_6      1402789               0               0               0               0
DIM3_ELEM_STRAIN_LOWER_7      1402789               0               0               0               0
DIM3_ELEM_STRAIN_LOWER_8      1402789               0               0               0               0
DIM3_ELEM_STRAIN_UPPER_0      1402789    -0.000368877       0.0116494      -0.2760010       0.2685880
DIM3_ELEM_STRAIN_UPPER_1      1402789     0.000058182       0.0068807      -0.1908090       0.1894050
DIM3_ELEM_STRAIN_UPPER_2      1402789               0               0               0               0
DIM3_ELEM_STRAIN_UPPER_3      1402789     0.000058182       0.0068807      -0.1908090       0.1894050
DIM3_ELEM_STRAIN_UPPER_4      1402789    -0.000364691       0.0116471      -0.2755610       0.2682810
DIM3_ELEM_STRAIN_UPPER_5      1402789               0               0               0               0
DIM3_ELEM_STRAIN_UPPER_6      1402789               0               0               0               0
DIM3_ELEM_STRAIN_UPPER_7      1402789               0               0               0               0
DIM3_ELEM_STRAIN_UPPER_8      1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_1_0    1402789       0.0058980       0.2016447      -1.0397500       0.8605650
DIM3_ELEM_STRESS_LAYER_1_1    1402789      -0.0023278       0.0790402      -0.3947340       0.3939380
DIM3_ELEM_STRESS_LAYER_1_2    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_1_3    1402789      -0.0023278       0.0790402      -0.3947340       0.3939380
DIM3_ELEM_STRESS_LAYER_1_4    1402789       0.0058346       0.2017027      -1.0427500       0.8607460
DIM3_ELEM_STRESS_LAYER_1_5    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_1_6    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_1_7    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_1_8    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_2_0    1402789       0.0014902       0.1727825      -0.9662910       0.7592050
DIM3_ELEM_STRESS_LAYER_2_1    1402789      -0.0021281       0.0731967      -0.3558740       0.3957070
DIM3_ELEM_STRESS_LAYER_2_2    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_2_3    1402789      -0.0021281       0.0731967      -0.3558740       0.3957070
DIM3_ELEM_STRESS_LAYER_2_4    1402789       0.0014210       0.1728032      -0.9689550       0.7570470
DIM3_ELEM_STRESS_LAYER_2_5    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_2_6    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_2_7    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_2_8    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_3_0    1402789      -0.0070363       0.1442754      -0.8631480       0.7438650
DIM3_ELEM_STRESS_LAYER_3_1    1402789      -0.0024009       0.0720203      -0.3724180       0.4079060
DIM3_ELEM_STRESS_LAYER_3_2    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_3_3    1402789      -0.0024009       0.0720203      -0.3724180       0.4079060
DIM3_ELEM_STRESS_LAYER_3_4    1402789      -0.0070885       0.1442727      -0.8642890       0.7510850
DIM3_ELEM_STRESS_LAYER_3_5    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_3_6    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_3_7    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_3_8    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_4_0    1402789      -0.0022882       0.1713155      -0.8779460       0.8836200
DIM3_ELEM_STRESS_LAYER_4_1    1402789      -0.0024012       0.0776307      -0.3799050       0.3836530
DIM3_ELEM_STRESS_LAYER_4_2    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_4_3    1402789      -0.0024012       0.0776307      -0.3799050       0.3836530
DIM3_ELEM_STRESS_LAYER_4_4    1402789      -0.0023200       0.1713366      -0.8784470       0.8834720
DIM3_ELEM_STRESS_LAYER_4_5    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_4_6    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_4_7    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_4_8    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_5_0    1402789     0.000786097       0.1998782      -0.8807760       0.9026250
DIM3_ELEM_STRESS_LAYER_5_1    1402789      -0.0021987       0.0836008      -0.4105020       0.4124400
DIM3_ELEM_STRESS_LAYER_5_2    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_5_3    1402789      -0.0021987       0.0836008      -0.4105020       0.4124400
DIM3_ELEM_STRESS_LAYER_5_4    1402789     0.000755100       0.1999217      -0.8808040       0.9027020
DIM3_ELEM_STRESS_LAYER_5_5    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_5_6    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_5_7    1402789               0               0               0               0
DIM3_ELEM_STRESS_LAYER_5_8    1402789               0               0               0               0
DIM3_ELEM_STRESS_LOWER_0      1402789       0.0058980       0.2016447      -1.0397500       0.8605650
DIM3_ELEM_STRESS_LOWER_1      1402789      -0.0023278       0.0790402      -0.3947340       0.3939380
DIM3_ELEM_STRESS_LOWER_2      1402789               0               0               0               0
DIM3_ELEM_STRESS_LOWER_3      1402789      -0.0023278       0.0790402      -0.3947340       0.3939380
DIM3_ELEM_STRESS_LOWER_4      1402789       0.0058346       0.2017027      -1.0427500       0.8607460
DIM3_ELEM_STRESS_LOWER_5      1402789               0               0               0               0
DIM3_ELEM_STRESS_LOWER_6      1402789               0               0               0               0
DIM3_ELEM_STRESS_LOWER_7      1402789               0               0               0               0
DIM3_ELEM_STRESS_LOWER_8      1402789               0               0               0               0
DIM3_ELEM_STRESS_UPPER_0      1402789     0.000786097       0.1998782      -0.8807760       0.9026250
DIM3_ELEM_STRESS_UPPER_1      1402789      -0.0021987       0.0836008      -0.4105020       0.4124400
DIM3_ELEM_STRESS_UPPER_2      1402789               0               0               0               0
DIM3_ELEM_STRESS_UPPER_3      1402789      -0.0021987       0.0836008      -0.4105020       0.4124400
DIM3_ELEM_STRESS_UPPER_4      1402789     0.000755100       0.1999217      -0.8808040       0.9027020
DIM3_ELEM_STRESS_UPPER_5      1402789               0               0               0               0
DIM3_ELEM_STRESS_UPPER_6      1402789               0               0               0               0
DIM3_ELEM_STRESS_UPPER_7      1402789               0               0               0               0
DIM3_ELEM_STRESS_UPPER_8      1402789               0               0               0               0
DIM3_ELEM_VON_MISES           1402789       0.1401254       0.1107826               0       0.7366310
ELEMENT_ID                    1402789         6685.56         4003.44               0        13626.00
EROSION_STATUS                1402789       1.0000000               0       1.0000000       1.0000000
PART_ID                       1402789      13.1357909       5.9757607       1.0000000      24.0000000
CELL_TYPE                     1402789       8.8966088       0.7507184       3.0000000       9.0000000

/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

1                                          Altair SLC           16:20 Tuesday, May 26, 2026

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿ods _all_ close;

NOTE: AUTOEXEC processing completed

1          data WORKx.CELL_DATA    ;
2         infile "d:/rad/cell_data.csv" delimiter = ',' MISSOVER DSD lrecl=32756 firstobs=2 ;
3
4         LABEL
5             ELEMENT_ID = "Element identification number"
6             EROSION_STATUS = "Element erosion flag (0=active, 1=eroded)"
7             PART_ID = "Part identification number"
8             CELL_TYPE = "Element cell type (e.g., hex, tet, wedge)"
9             DIM3_ELEM_PLASTIC_STRAIN = "Plastic strain (3D element)"
10            DIM3_ELEM_STRAIN_LAYER_1_0 = "Element strain - Layer 1, integration point 0"
11            DIM3_ELEM_STRAIN_LAYER_1_1 = "Element strain - Layer 1, integration point 1"
12            DIM3_ELEM_STRAIN_LAYER_1_2 = "Element strain - Layer 1, integration point 2"
13            DIM3_ELEM_STRAIN_LAYER_1_3 = "Element strain - Layer 1, integration point 3"
14            DIM3_ELEM_STRAIN_LAYER_1_4 = "Element strain - Layer 1, integration point 4"
15            DIM3_ELEM_STRAIN_LAYER_1_5 = "Element strain - Layer 1, integration point 5"
16            DIM3_ELEM_STRAIN_LAYER_1_6 = "Element strain - Layer 1, integration point 6"
17            DIM3_ELEM_STRAIN_LAYER_1_7 = "Element strain - Layer 1, integration point 7"
18            DIM3_ELEM_STRAIN_LAYER_1_8 = "Element strain - Layer 1, integration point 8"
19            DIM3_ELEM_VON_MISES = "Von Mises stress (3D element)"
20        ;
21        input
22          DIM3_ELEM_Plastic_Strain
23          DIM3_ELEM_Strain_layer_1_0
24          DIM3_ELEM_Strain_layer_1_1
25          DIM3_ELEM_Strain_layer_1_2
26          DIM3_ELEM_Strain_layer_1_3
27          DIM3_ELEM_Strain_layer_1_4
28          DIM3_ELEM_Strain_layer_1_5
29          DIM3_ELEM_Strain_layer_1_6
30          DIM3_ELEM_Strain_layer_1_7
31          DIM3_ELEM_Strain_layer_1_8
            ....
140         DIM3_ELEM_Stress_upper_0
141         DIM3_ELEM_Stress_upper_1
142         DIM3_ELEM_Stress_upper_2
143         DIM3_ELEM_Stress_upper_3
144         DIM3_ELEM_Stress_upper_4
145         DIM3_ELEM_Stress_upper_5
146         DIM3_ELEM_Stress_upper_6
147         DIM3_ELEM_Stress_upper_7
148         DIM3_ELEM_Stress_upper_8
149         DIM3_ELEM_Von_Mises
150         ELEMENT_ID
151         EROSION_STATUS
152         PART_ID
153         Cell_Type
154         empty best32.
155       ;
156       run;

NOTE: The infile 'd:\rad\cell_data.csv' is:
      Filename='d:\rad\cell_data.csv',
      Owner Name=SLC\suzie,
      File size (bytes)=1561500820,
      Create Time=18:37:40 May 25 2026,
      Last Accessed=13:19:41 May 26 2026,
      Last Modified=18:40:57 May 25 2026,
      Lrecl=32756, Recfm=V

NOTE: 1402789 records were read from file 'd:\rad\cell_data.csv'
      The minimum record length was 263
      The maximum record length was 1217
NOTE: Data set "WORKX.CELL_DATA" has 1402789 observation(s) and 133 variable(s)
NOTE: The data step took :
      real time : 47.835
      cpu time  : 47.671


157
158       proc means data=WORKX.CELL_data n mean std min max;
159       run;
NOTE: 1402789 observations were read from "WORKX.CELL_data"
NOTE: Procedure means step took :
      real time : 6.456
      cpu time  : 6.406


ERROR: Error printed on page 1

NOTE: Submitted statements took :
      real time : 54.371
      cpu time  : 54.156


/*     _       _           _
  __ _| | ___ | |__   __ _| |   ___ _ __   ___ _ __ __ _ _   _
 / _` | |/ _ \| `_ \ / _` | |  / _ \ `_ \ / _ \ `__/ _` | | | |
| (_| | | (_) | |_) | (_| | | |  __/ | | |  __/ | | (_| | |_| |
 \__, |_|\___/|_.__/ \__,_|_|  \___|_| |_|\___|_|  \__, |\__, |
 |___/                                             |___/ |___/
*/


data WORKX.GLOBAL_ENERGY (drop=empty);  /*--- handle extra comma ---*/

infile "d:/rad/global_energy_data.csv" delimiter = ',' MISSOVER DSD lrecl=32756 firstobs=2 ;

label
             NODE_ID   = "Node identification number"
             Points_0  = "X-coordinate (mm)"
             Points_1  = "Y-coordinate (mm)"
             Points_2  = "Z-coordinate (mm)"
;

input
            NODE_ID
            Points_0
            Points_1
            Points_2 empty best32.
;
run;

/**************************************************************************************************************************/
/*   WORKX.GLOBAL_ENERGY total                                                                                            */
/*                                                                                                                        */
/*  Obs       NODE_ID      POINTS_0    POINTS_1    POINTS_2                                                               */
/*                                                                                                                        */
/*    1    9221373786.4     -62.931    -3.83516     0.16944                                                               */
/*    2    9221104480.0     -65.075    -3.83492     0.17199                                                               */
/*    3    9219926557.4     -66.329    -3.82940     0.20751                                                               */
/*    4    9219488874.2     -68.052    -3.83161     0.19400                                                               */
/*    5    9218942830.2     -69.895    -3.83164     0.19295                                                               */
/*   ...                                                                                                                  */
/*   97    9219280732.5    -125.007    -3.95623    -0.21276                                                               */
/*   98    9219195514.9    -124.805    -3.95577    -0.21581                                                               */
/*   99    9219122722.1    -124.592    -3.95627    -0.21699                                                               */
/*  100    9219036801.5    -124.372    -3.95738    -0.21435                                                               */
/*  101    9218959226.2    -124.145    -3.95713    -0.21369                                                               */
/**************************************************************************************************************************/
/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/

1                                          Altair SLC           15:39 Tuesday, May 26, 2026

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿ods _all_ close;
           ^
ERROR: Expected a statement keyword : found "?"

NOTE: AUTOEXEC processing completed

1           data WORKX.GLOBAL_ENERGY(drop=empty);  /*--- handle extra comma ---*/
2
3         infile "d:/rad/global_energy_data.csv" delimiter = ',' MISSOVER DSD lrecl=32756 firstobs=2 ;
4
5         label
6                      NODE_ID   = "Node identification number"
7                      Points_0  = "X-coordinate (mm)"
8                      Points_1  = "Y-coordinate (mm)"
9                      Points_2  = "Z-coordinate (mm)"
10        ;
11
12        input
13                    NODE_ID
14                    Points_0
15                    Points_1
16                    Points_2 empty best32.
17        ;
18        run;

NOTE: The infile 'd:\rad\global_energy_data.csv' is:
      Filename='d:\rad\global_energy_data.csv',
      Owner Name=SLC\suzie,
      File size (bytes)=6154,
      Create Time=18:33:44 May 25 2026,
      Last Accessed=15:39:14 May 26 2026,
      Last Modified=18:37:40 May 25 2026,
      Lrecl=32756, Recfm=V

NOTE: 101 records were read from file 'd:\rad\global_energy_data.csv'
      The minimum record length was 55
      The maximum record length was 61
NOTE: Data set "WORKX.GLOBAL_ENERGY" has 101 observation(s) and 4 variable(s)
NOTE: The data step took :
      real time : 0.015
      cpu time  : 0.000


ERROR: Error printed on page 1

NOTE: Submitted statements took :
      real time : 0.095
      cpu time  : 0.062

/*  ___                       _                         _  _     __                             _   _       _  __
/ |/ _ \   ___ _ __ ___  __ _| |_ ___   _ __ ___  _ __ | || |   / _|_ __ ___  _ __ ___   __   _| |_| | ____| |/ _|
| | | | | / __| `__/ _ \/ _` | __/ _ \ | `_ ` _ \| `_ \| || |_ | |_| `__/ _ \| `_ ` _ \  \ \ / / __| |/ / _` | |_
| | |_| || (__| | |  __/ (_| | ||  __/ | | | | | | |_) |__   _||  _| | | (_) | | | | | |  \ V /| |_|   < (_| |  _|
|_|\___/  \___|_|  \___|\__,_|\__\___| |_| |_| |_| .__/   |_|  |_| |_|  \___/|_| |_| |_|   \_/  \__|_|\_\__,_|_|
                                                 |_|
*/

%slc_pvpybegin;
cards4;
#!/usr/bin/env python
"""
Convert VTKHDF to MP4 with Von Mises stress coloring for Bumper Beam.
"""

from paraview.simple import *
import os
import subprocess

# ============================================================
# CONFIGURATION
# ============================================================
VTKHDF_FILE = "D:/rad/Bumper_Beam_AP_meshed.vtkhdf"
OUTPUT_DIR = "D:/rad/frames"
OUTPUT_VIDEO = "D:/rad/bump_animation.mp4"
FRAME_RATE = 30

IMAGE_WIDTH = 1920
IMAGE_HEIGHT = 1080

CAMERA_POSITION = [0, 0, 15]
CAMERA_FOCAL_POINT = [0, 0, 0]
CAMERA_VIEW_UP = [0, 1, 0]
USE_PARALLEL_PROJECTION = True
PARALLEL_SCALE = 5.0

# Use Von Mises stress from cell data
COLOR_ARRAY = "2DELEM_Von_Mises"
COLOR_MAP = "Cool to Warm"

# ============================================================
# CREATE OUTPUT DIRECTORY
# ============================================================
os.makedirs(OUTPUT_DIR, exist_ok=True)

print("=" * 60)
print("VTKHDF to MP4 Converter with Von Mises Stress")
print("=" * 60)
print(f"Input file: {VTKHDF_FILE}")
print(f"Output video: {OUTPUT_VIDEO}")
print(f"Frame rate: {FRAME_RATE} fps")

# ============================================================
# LOAD THE VTKHDF FILE
# ============================================================
if not os.path.exists(VTKHDF_FILE):
    print(f"ERROR: File not found: {VTKHDF_FILE}")
    exit(1)

print("\nLoading VTKHDF file...")
source = OpenDataFile(VTKHDF_FILE)
source.UpdatePipeline()

timesteps = source.TimestepValues
num_frames = len(timesteps) if timesteps else 1
print(f"Found {num_frames} time steps")

print(f"Point Data: {list(source.PointData.keys())}")
print(f"Cell Data: {list(source.CellData.keys())}")

# ============================================================
# STEP 1: CONVERT CELL DATA TO POINT DATA (CRITICAL!)
# ============================================================
print(f"\nConverting cell data to point data...")
cell_to_point = CellDatatoPointData(Input=source)
cell_to_point.UpdatePipeline()

# Now the array will be available in Point Data
print(f"Point Data after conversion: {list(cell_to_point.PointData.keys())}")

# ============================================================
# CREATE RENDER VIEW
# ============================================================
print("\nSetting up render view...")
renderView = CreateView('RenderView')
renderView.ViewSize = [IMAGE_WIDTH, IMAGE_HEIGHT]
AssignViewToLayout(renderView)

# Show the CONVERTED data
display = Show(cell_to_point, renderView)
display.Representation = 'Surface'

# ============================================================
# APPLY COLORING USING VON MISES STRESS
# ============================================================
print(f"\nApplying coloring using '{COLOR_ARRAY}'...")

if COLOR_ARRAY in cell_to_point.PointData.keys():
    # Color by point data
    display.ColorArrayName = ['POINTS', COLOR_ARRAY]
    display.SetScalarBarVisibility(renderView, True)

    # Get the color transfer function
    lut = GetColorTransferFunction(COLOR_ARRAY)

    if COLOR_MAP == "Cool to Warm":
        lut.ColorSpace = 'Diverging'
    elif COLOR_MAP == "Jet":
        lut.ColorSpace = 'RGB'

    # Get the actual data range
    data_range = cell_to_point.PointData.GetArray(COLOR_ARRAY).GetRange()
    print(f"  Data range: {data_range[0]:.6f} to {data_range[1]:.6f}")

    if data_range[1] > data_range[0]:
        lut.RescaleTransferFunction(data_range[0], data_range[1])
        print(f"  Color map '{COLOR_MAP}' applied")
    else:
        print("  WARNING: Data range is zero - no variation in data")
else:
    print(f"  ERROR: '{COLOR_ARRAY}' not found in Point Data after conversion")
    print("  Available arrays:", list(cell_to_point.PointData.keys()))

renderView.Background = [0.1, 0.2, 0.4]

# ============================================================
# SET UP CAMERA
# ============================================================
renderView.CameraPosition = CAMERA_POSITION
renderView.CameraFocalPoint = CAMERA_FOCAL_POINT
renderView.CameraViewUp = CAMERA_VIEW_UP

if USE_PARALLEL_PROJECTION:
    renderView.CameraParallelProjection = 1
    renderView.CameraParallelScale = PARALLEL_SCALE
else:
    renderView.CameraParallelProjection = 0

renderView.ResetCamera()
Render()

# ============================================================
# CONFIGURE ANIMATION
# ============================================================
animationScene = GetAnimationScene()
animationScene.NumberOfFrames = num_frames
animationScene.StartTime = 0
animationScene.EndTime = num_frames - 1
animationScene.PlayMode = 'Sequence'

# ============================================================
# SAVE FRAMES
# ============================================================
print(f"\nSaving {num_frames} frames to {OUTPUT_DIR}...")

for i in range(num_frames):
    animationScene.TimeKeeper.Time = i
    cell_to_point.UpdatePipeline(i)
    Render()

    frame_file = os.path.join(OUTPUT_DIR, f"frame_{i+1:04d}.png")
    SaveScreenshot(frame_file, renderView, ImageResolution=[IMAGE_WIDTH, IMAGE_HEIGHT])

    if (i + 1) % 10 == 0 or (i + 1) == num_frames:
        print(f"  Saved frame {i+1}/{num_frames}")

print(f"\nFrames saved to: {OUTPUT_DIR}")

# ============================================================
# CONVERT TO MP4
# ============================================================
print("\n" + "=" * 50)
print("Converting PNG sequence to MP4...")
print("=" * 50)

ffmpeg_cmd = None
ffmpeg_paths = ['ffmpeg', 'C:\\ffmpeg\\bin\\ffmpeg.exe', 'D:\\ffmpeg\\bin\\ffmpeg.exe']

for path in ffmpeg_paths:
    try:
        subprocess.run([path, '-version'], capture_output=True, check=True)
        ffmpeg_cmd = path
        break
    except (subprocess.SubprocessError, FileNotFoundError):
        continue

if ffmpeg_cmd:
    input_pattern = os.path.join(OUTPUT_DIR, "frame_%04d.png").replace('\\', '/')
    output_video = OUTPUT_VIDEO.replace('\\', '/')

    ffmpeg_command = [
        ffmpeg_cmd, '-framerate', str(FRAME_RATE),
        '-i', input_pattern,
        '-vf', 'pad=1920:1062:(ow-iw)/2:(oh-ih)/2',
        '-c:v', 'libx264',
        '-pix_fmt', 'yuv420p',
        '-crf', '18',
        '-y', output_video
    ]

    print(f"Running FFmpeg...")
    try:
        result = subprocess.run(ffmpeg_command, capture_output=True, text=True)
        if result.returncode == 0 and os.path.exists(OUTPUT_VIDEO):
            size_mb = os.path.getsize(OUTPUT_VIDEO) / (1024 * 1024)
            print(f"\nSUCCESS! MP4 created: {OUTPUT_VIDEO}")
            print(f"File size: {size_mb:.2f} MB")
        else:
            print(f"\nFFmpeg failed. Run this command manually:")
            print(f'ffmpeg -framerate {FRAME_RATE} -i "{OUTPUT_DIR}/frame_%04d.png" -vf "pad=1920:1062:(ow-iw)/2:(oh-ih)/2" -c:v libx264 -pix_fmt yuv420p -crf 18 -y {OUTPUT_VIDEO}')
    except Exception as e:
        print(f"\nError: {e}")
        print(f'ffmpeg -framerate {FRAME_RATE} -i "{OUTPUT_DIR}/frame_%04d.png" -vf "pad=1920:1062:(ow-iw)/2:(oh-ih)/2" -c:v libx264 -pix_fmt yuv420p -crf 18 -y {OUTPUT_VIDEO}')
else:
    print("\nFFmpeg not found. Run this command manually:")
    print(f'ffmpeg -framerate {FRAME_RATE} -i "{OUTPUT_DIR}/frame_%04d.png" -vf "pad=1920:1062:(ow-iw)/2:(oh-ih)/2" -c:v libx264 -pix_fmt yuv420p -crf 18 -y {OUTPUT_VIDEO}')

print("\n" + "=" * 60)
print("PROCESS COMPLETE")
print("=" * 60)
print(f"Animation saved to: {OUTPUT_VIDEO}")
;;;;
%slc_pvpyend;


/**************************************************************************************************************************/
/*  Altair SLC                                                                                                            */
/* ============================================================                                                           */
/* VTKHDF to MP4 Converter with Von Mises Stress                                                                          */
/* ============================================================                                                           */
/* Input file: D:/rad/Bumper_Beam_AP_meshed.vtkhdf                                                                        */
/* Output video: D:/rad/bump_animation.mp4                                                                                */
/* Frame rate: 30 fps                                                                                                     */
/*                                                                                                                        */
/* Loading VTKHDF file...                                                                                                 */
/* Found 101 time steps                                                                                                   */
/* Point Data: ['NODE_ID']                                                                                                */
/* Cell Data: ['2DELEM_Plastic_Strain', '2DELEM_Strain_(layer__1)_', '2DELEM_Strain_(layer__2)_',                         */
/*  '2DELEM_Strain_(layer__3)_', '2DELEM_Strain_(layer__4)_', '2DELEM_Strain_(layer__5)_',                                */
/*  '2DELEM_Strain_(lower)', '2DELEM_Strain_(upper)', '2DELEM_Stress_(layer__                                             */
/* 1)_', '2DELEM_Stress_(layer__2)_', '2DELEM_Stress_(layer__3)_', '2DELEM_Stress_(layer__4)_',                           */
/*  '2DELEM_Stress_(layer__5)_', '2DELEM_Stress_(lower)', '2DELEM_Stress_(upper)', '2DELEM_Von_Mises',                    */
/*  'ELEMENT_ID', 'EROSION_STATUS', 'PART_ID']                                                                            */
/*                                                                                                                        */
/* Converting cell data to point data...                                                                                  */
/* Point Data after conversion: ['NODE_ID', '2DELEM_Plastic_Strain', '2DELEM_Strain_(layer__1)_',                         */
/*  '2DELEM_Strain_(layer__2)_', '2DELEM_Strain_(layer__3)_', '2DELEM_Strain_(layer__4)_',                                */
/*  '2DELEM_Strain_(layer__5)_', '2DELEM_Strain_(lower)', '2DELEM_Strain_(upp                                             */
/* er)', '2DELEM_Stress_(layer__1)_', '2DELEM_Stress_(layer__2)_', '2DELEM_Stress_(layer__3)_',                           */
/*  '2DELEM_Stress_(layer__4)_', '2DELEM_Stress_(layer__5)_', '2DELEM_Stress_(lower)',                                    */
/*  '2DELEM_Stress_(upper)', '2DELEM_Von_Mises', 'ELEMENT_ID', 'EROSION_STATUS', 'P                                       */
/* ART_ID']                                                                                                               */
/*                                                                                                                        */
/* Setting up render view...                                                                                              */
/*                                                                                                                        */
/* Applying coloring using '2DELEM_Von_Mises'...                                                                          */
/*   Data range: 0.000000 to 0.000000                                                                                     */
/*   WARNING: Data range is zero - no variation in data                                                                   */
/*                                                                                                                        */
/* Saving 101 frames to D:/rad/frames...                                                                                  */
/*   Saved frame 10/101                                                                                                   */
/*   Saved frame 20/101                                                                                                   */
/*   Saved frame 30/101                                                                                                   */
/*   Saved frame 40/101                                                                                                   */
/*   Saved frame 50/101                                                                                                   */
/*   Saved frame 60/101                                                                                                   */
/*   Saved frame 70/101                                                                                                   */
/*   Saved frame 80/101                                                                                                   */
/*   Saved frame 90/101                                                                                                   */
/*   Saved frame 100/101                                                                                                  */
/*   Saved frame 101/101                                                                                                  */
/*                                                                                                                        */
/* Frames saved to: D:/rad/frames                                                                                         */
/*                                                                                                                        */
/* ==================================================                                                                     */
/* Converting PNG sequence to MP4...                                                                                      */
/* ==================================================                                                                     */
/* Running FFmpeg...                                                                                                      */
/*                                                                                                                        */
/* SUCCESS! MP4 created: D:/rad/bump_animation.mp4                                                                        */
/* File size: 0.14 MB                                                                                                     */
/*                                                                                                                        */
/* ============================================================                                                           */
/* PROCESS COMPLETE                                                                                                       */
/* ============================================================                                                           */
/* Animation saved to: D:/rad/bump_animation.mp4                                                                          */
/**************************************************************************************************************************/

/*
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
*/
1                                          Altair SLC           15:48 Tuesday, May 26, 2026

NOTE: Copyright 2002-2025 World Programming, an Altair Company
NOTE: Altair SLC 2026 (05.26.01.00.000758)
      Licensed to Roger DeAngelis
NOTE: This session is executing on the X64_WIN11PRO platform and is running in 64 bit mode

NOTE: AUTOEXEC processing beginning; file is C:\wpsoto\autoexec.sas
NOTE: AUTOEXEC source line
1       +  ï»¿ods _all_ close;
           ^
ERROR: Expected a statement keyword : found "?"

NOTE: AUTOEXEC processing completed

1          %slc_pvpybegin;
The file c:/temp/py_pgm.py does not exist
2         cards4;

NOTE: The file 'c:\temp\py_pgmx.py' is:
      Filename='c:\temp\py_pgmx.py',
      Owner Name=SLC\suzie,
      File size (bytes)=0,
      Create Time=13:21:25 Jan 12 2026,
      Last Accessed=15:48:06 May 26 2026,
      Last Modified=15:48:06 May 26 2026,
      Lrecl=32767, Recfm=V

NOTE: 211 records were written to file 'c:\temp\py_pgmx.py'
      The minimum record length was 80
      The maximum record length was 181
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.015


3         #!/usr/bin/env python
4         """
5         Convert VTKHDF to MP4 with Von Mises stress coloring for Bumper Beam.
6         """
7
8         from paraview.simple import *
9         import os
10        import subprocess
11
12        # ============================================================
13        # CONFIGURATION
14        # ============================================================
15        VTKHDF_FILE = "D:/rad/Bumper_Beam_AP_meshed.vtkhdf"
16        OUTPUT_DIR = "D:/rad/frames"
17        OUTPUT_VIDEO = "D:/rad/bump_animation.mp4"
18        FRAME_RATE = 30
19
20        IMAGE_WIDTH = 1920
21        IMAGE_HEIGHT = 1080
22
23        CAMERA_POSITION = [0, 0, 15]
24        CAMERA_FOCAL_POINT = [0, 0, 0]
25        CAMERA_VIEW_UP = [0, 1, 0]
26        USE_PARALLEL_PROJECTION = True
27        PARALLEL_SCALE = 5.0
28
29        # Use Von Mises stress from cell data
30        COLOR_ARRAY = "2DELEM_Von_Mises"
31        COLOR_MAP = "Cool to Warm"
32
33        # ============================================================
34        # CREATE OUTPUT DIRECTORY
35        # ============================================================
36        os.makedirs(OUTPUT_DIR, exist_ok=True)
37
38        print("=" * 60)
39        print("VTKHDF to MP4 Converter with Von Mises Stress")
40        print("=" * 60)
41        print(f"Input file: {VTKHDF_FILE}")
42        print(f"Output video: {OUTPUT_VIDEO}")
43        print(f"Frame rate: {FRAME_RATE} fps")
44
45        # ============================================================
46        # LOAD THE VTKHDF FILE
47        # ============================================================
48        if not os.path.exists(VTKHDF_FILE):
49            print(f"ERROR: File not found: {VTKHDF_FILE}")
50            exit(1)
51
52        print("\nLoading VTKHDF file...")
53        source = OpenDataFile(VTKHDF_FILE)
54        source.UpdatePipeline()
55
56        timesteps = source.TimestepValues
57        num_frames = len(timesteps) if timesteps else 1
58        print(f"Found {num_frames} time steps")
59
60        print(f"Point Data: {list(source.PointData.keys())}")
61        print(f"Cell Data: {list(source.CellData.keys())}")
62
63        # ============================================================
64        # STEP 1: CONVERT CELL DATA TO POINT DATA (CRITICAL!)
65        # ============================================================
66        print(f"\nConverting cell data to point data...")
67        cell_to_point = CellDatatoPointData(Input=source)
68        cell_to_point.UpdatePipeline()
69
70        # Now the array will be available in Point Data
71        print(f"Point Data after conversion: {list(cell_to_point.PointData.keys())}")
72
73        # ============================================================
74        # CREATE RENDER VIEW
75        # ============================================================
76        print("\nSetting up render view...")
77        renderView = CreateView('RenderView')
78        renderView.ViewSize = [IMAGE_WIDTH, IMAGE_HEIGHT]
79        AssignViewToLayout(renderView)
80
81        # Show the CONVERTED data
82        display = Show(cell_to_point, renderView)
83        display.Representation = 'Surface'
84
85        # ============================================================
86        # APPLY COLORING USING VON MISES STRESS
87        # ============================================================
88        print(f"\nApplying coloring using '{COLOR_ARRAY}'...")
89
90        if COLOR_ARRAY in cell_to_point.PointData.keys():
91            # Color by point data
92            display.ColorArrayName = ['POINTS', COLOR_ARRAY]
93            display.SetScalarBarVisibility(renderView, True)
94
95            # Get the color transfer function
96            lut = GetColorTransferFunction(COLOR_ARRAY)
97
98            if COLOR_MAP == "Cool to Warm":
99                lut.ColorSpace = 'Diverging'
100           elif COLOR_MAP == "Jet":
101               lut.ColorSpace = 'RGB'
102
103           # Get the actual data range
104           data_range = cell_to_point.PointData.GetArray(COLOR_ARRAY).GetRange()
105           print(f"  Data range: {data_range[0]:.6f} to {data_range[1]:.6f}")
106
107           if data_range[1] > data_range[0]:
108               lut.RescaleTransferFunction(data_range[0], data_range[1])
109               print(f"  Color map '{COLOR_MAP}' applied")
110           else:
111               print("  WARNING: Data range is zero - no variation in data")
112       else:
113           print(f"  ERROR: '{COLOR_ARRAY}' not found in Point Data after conversion")
114           print("  Available arrays:", list(cell_to_point.PointData.keys()))
115
116       renderView.Background = [0.1, 0.2, 0.4]
117
118       # ============================================================
119       # SET UP CAMERA
120       # ============================================================
121       renderView.CameraPosition = CAMERA_POSITION
122       renderView.CameraFocalPoint = CAMERA_FOCAL_POINT
123       renderView.CameraViewUp = CAMERA_VIEW_UP
124
125       if USE_PARALLEL_PROJECTION:
126           renderView.CameraParallelProjection = 1
127           renderView.CameraParallelScale = PARALLEL_SCALE
128       else:
129           renderView.CameraParallelProjection = 0
130
131       renderView.ResetCamera()
132       Render()
133
134       # ============================================================
135       # CONFIGURE ANIMATION
136       # ============================================================
137       animationScene = GetAnimationScene()
138       animationScene.NumberOfFrames = num_frames
139       animationScene.StartTime = 0
140       animationScene.EndTime = num_frames - 1
141       animationScene.PlayMode = 'Sequence'
142
143       # ============================================================
144       # SAVE FRAMES
145       # ============================================================
146       print(f"\nSaving {num_frames} frames to {OUTPUT_DIR}...")
147
148       for i in range(num_frames):
149           animationScene.TimeKeeper.Time = i
150           cell_to_point.UpdatePipeline(i)
151           Render()
152
153           frame_file = os.path.join(OUTPUT_DIR, f"frame_{i+1:04d}.png")
154           SaveScreenshot(frame_file, renderView, ImageResolution=[IMAGE_WIDTH, IMAGE_HEIGHT])
155
156           if (i + 1) % 10 == 0 or (i + 1) == num_frames:
157               print(f"  Saved frame {i+1}/{num_frames}")
158
159       print(f"\nFrames saved to: {OUTPUT_DIR}")
160
161       # ============================================================
162       # CONVERT TO MP4
163       # ============================================================
164       print("\n" + "=" * 50)
165       print("Converting PNG sequence to MP4...")
166       print("=" * 50)
167
168       ffmpeg_cmd = None
169       ffmpeg_paths = ['ffmpeg', 'C:\\ffmpeg\\bin\\ffmpeg.exe', 'D:\\ffmpeg\\bin\\ffmpeg.exe']
170
171       for path in ffmpeg_paths:
172           try:
173               subprocess.run([path, '-version'], capture_output=True, check=True)
174               ffmpeg_cmd = path
175               break
176           except (subprocess.SubprocessError, FileNotFoundError):
177               continue
178
179       if ffmpeg_cmd:
180           input_pattern = os.path.join(OUTPUT_DIR, "frame_%04d.png").replace('\\', '/')
181           output_video = OUTPUT_VIDEO.replace('\\', '/')
182
183           ffmpeg_command = [
184               ffmpeg_cmd, '-framerate', str(FRAME_RATE),
185               '-i', input_pattern,
186               '-vf', 'pad=1920:1062:(ow-iw)/2:(oh-ih)/2',
187               '-c:v', 'libx264',
188               '-pix_fmt', 'yuv420p',
189               '-crf', '18',
190               '-y', output_video
191           ]
192
193           print(f"Running FFmpeg...")
194           try:
195               result = subprocess.run(ffmpeg_command, capture_output=True, text=True)
196               if result.returncode == 0 and os.path.exists(OUTPUT_VIDEO):
197                   size_mb = os.path.getsize(OUTPUT_VIDEO) / (1024 * 1024)
198                   print(f"\nSUCCESS! MP4 created: {OUTPUT_VIDEO}")
199                   print(f"File size: {size_mb:.2f} MB")
200               else:
201                   print(f"\nFFmpeg failed. Run this command manually:")
202                   print(f'ffmpeg -framerate {FRAME_RATE} -i "{OUTPUT_DIR}/frame_%04d.png" -vf "pad=1920:1062:(ow-iw)/2:(oh-ih)/2" -c:v libx264 -pix_fmt yuv420p -crf 18 -y {OUTPUT_VIDEO}')
203           except Exception as e:
204               print(f"\nError: {e}")
205               print(f'ffmpeg -framerate {FRAME_RATE} -i "{OUTPUT_DIR}/frame_%04d.png" -vf "pad=1920:1062:(ow-iw)/2:(oh-ih)/2" -c:v libx264 -pix_fmt yuv420p -crf 18 -y {OUTPUT_VIDEO}')
206       else:
207           print("\nFFmpeg not found. Run this command manually:")
208           print(f'ffmpeg -framerate {FRAME_RATE} -i "{OUTPUT_DIR}/frame_%04d.png" -vf "pad=1920:1062:(ow-iw)/2:(oh-ih)/2" -c:v libx264 -pix_fmt yuv420p -crf 18 -y {OUTPUT_VIDEO}')
209
210       print("\n" + "=" * 60)
211       print("PROCESS COMPLETE")
212       print("=" * 60)
213       print(f"Animation saved to: {OUTPUT_VIDEO}")
214       ;;;;
215       %slc_pvpyend;

NOTE: The infile 'c:\temp\py_pgmx.py' is:
      Filename='c:\temp\py_pgmx.py',
      Owner Name=SLC\suzie,
      File size (bytes)=17608,
      Create Time=13:21:25 Jan 12 2026,
      Last Accessed=15:48:06 May 26 2026,
      Last Modified=15:48:06 May 26 2026,
      Lrecl=32767, Recfm=V

NOTE: The file 'c:\temp\py_pgm.py' is:
      Filename='c:\temp\py_pgm.py',
      Owner Name=SLC\suzie,
      File size (bytes)=0,
      Create Time=16:38:15 May 12 2026,
      Last Accessed=15:48:06 May 26 2026,
      Last Modified=15:48:06 May 26 2026,
      Lrecl=32767, Recfm=V

#!/usr/bin/env python
"""
Convert VTKHDF to MP4 with Von Mises stress coloring for Bumper Beam.
"""

from paraview.simple import *
import os
import subprocess

# ============================================================
# CONFIGURATION
# ============================================================
VTKHDF_FILE = "D:/rad/Bumper_Beam_AP_meshed.vtkhdf"
OUTPUT_DIR = "D:/rad/frames"
OUTPUT_VIDEO = "D:/rad/bump_animation.mp4"
FRAME_RATE = 30

IMAGE_WIDTH = 1920
IMAGE_HEIGHT = 1080

CAMERA_POSITION = [0, 0, 15]
CAMERA_FOCAL_POINT = [0, 0, 0]
CAMERA_VIEW_UP = [0, 1, 0]
USE_PARALLEL_PROJECTION = True
PARALLEL_SCALE = 5.0

# Use Von Mises stress from cell data
COLOR_ARRAY = "2DELEM_Von_Mises"
COLOR_MAP = "Cool to Warm"

# ============================================================
# CREATE OUTPUT DIRECTORY
# ============================================================
os.makedirs(OUTPUT_DIR, exist_ok=True)

print("=" * 60)
print("VTKHDF to MP4 Converter with Von Mises Stress")
print("=" * 60)
print(f"Input file: {VTKHDF_FILE}")
print(f"Output video: {OUTPUT_VIDEO}")
print(f"Frame rate: {FRAME_RATE} fps")

# ============================================================
# LOAD THE VTKHDF FILE
# ============================================================
if not os.path.exists(VTKHDF_FILE):
    print(f"ERROR: File not found: {VTKHDF_FILE}")
    exit(1)

print("\nLoading VTKHDF file...")
source = OpenDataFile(VTKHDF_FILE)
source.UpdatePipeline()

timesteps = source.TimestepValues
num_frames = len(timesteps) if timesteps else 1
print(f"Found {num_frames} time steps")

print(f"Point Data: {list(source.PointData.keys())}")
print(f"Cell Data: {list(source.CellData.keys())}")

# ============================================================
# STEP 1: CONVERT CELL DATA TO POINT DATA (CRITICAL!)
# ============================================================
print(f"\nConverting cell data to point data...")
cell_to_point = CellDatatoPointData(Input=source)
cell_to_point.UpdatePipeline()

# Now the array will be available in Point Data
print(f"Point Data after conversion: {list(cell_to_point.PointData.keys())}")

# ============================================================
# CREATE RENDER VIEW
# ============================================================
print("\nSetting up render view...")
renderView = CreateView('RenderView')
renderView.ViewSize = [IMAGE_WIDTH, IMAGE_HEIGHT]
AssignViewToLayout(renderView)

# Show the CONVERTED data
display = Show(cell_to_point, renderView)
display.Representation = 'Surface'

# ============================================================
# APPLY COLORING USING VON MISES STRESS
# ============================================================
print(f"\nApplying coloring using '{COLOR_ARRAY}'...")

if COLOR_ARRAY in cell_to_point.PointData.keys():
    # Color by point data
    display.ColorArrayName = ['POINTS', COLOR_ARRAY]
    display.SetScalarBarVisibility(renderView, True)

    # Get the color transfer function
    lut = GetColorTransferFunction(COLOR_ARRAY)

    if COLOR_MAP == "Cool to Warm":
        lut.ColorSpace = 'Diverging'
    elif COLOR_MAP == "Jet":
        lut.ColorSpace = 'RGB'

    # Get the actual data range
    data_range = cell_to_point.PointData.GetArray(COLOR_ARRAY).GetRange()
    print(f"  Data range: {data_range[0]:.6f} to {data_range[1]:.6f}")

    if data_range[1] > data_range[0]:
        lut.RescaleTransferFunction(data_range[0], data_range[1])
        print(f"  Color map '{COLOR_MAP}' applied")
    else:
        print("  WARNING: Data range is zero - no variation in data")
else:
    print(f"  ERROR: '{COLOR_ARRAY}' not found in Point Data after conversion")
    print("  Available arrays:", list(cell_to_point.PointData.keys()))

renderView.Background = [0.1, 0.2, 0.4]

# ============================================================
# SET UP CAMERA
# ============================================================
renderView.CameraPosition = CAMERA_POSITION
renderView.CameraFocalPoint = CAMERA_FOCAL_POINT
renderView.CameraViewUp = CAMERA_VIEW_UP

if USE_PARALLEL_PROJECTION:
    renderView.CameraParallelProjection = 1
    renderView.CameraParallelScale = PARALLEL_SCALE
else:
    renderView.CameraParallelProjection = 0

renderView.ResetCamera()
Render()

# ============================================================
# CONFIGURE ANIMATION
# ============================================================
animationScene = GetAnimationScene()
animationScene.NumberOfFrames = num_frames
animationScene.StartTime = 0
animationScene.EndTime = num_frames - 1
animationScene.PlayMode = 'Sequence'

# ============================================================
# SAVE FRAMES
# ============================================================
print(f"\nSaving {num_frames} frames to {OUTPUT_DIR}...")

for i in range(num_frames):
    animationScene.TimeKeeper.Time = i
    cell_to_point.UpdatePipeline(i)
    Render()

    frame_file = os.path.join(OUTPUT_DIR, f"frame_{i+1:04d}.png")
    SaveScreenshot(frame_file, renderView, ImageResolution=[IMAGE_WIDTH, IMAGE_HEIGHT])

    if (i + 1) % 10 == 0 or (i + 1) == num_frames:
        print(f"  Saved frame {i+1}/{num_frames}")

print(f"\nFrames saved to: {OUTPUT_DIR}")

# ============================================================
# CONVERT TO MP4
# ============================================================
print("\n" + "=" * 50)
print("Converting PNG sequence to MP4...")
print("=" * 50)

ffmpeg_cmd = None
ffmpeg_paths = ['ffmpeg', 'C:\\ffmpeg\\bin\\ffmpeg.exe', 'D:\\ffmpeg\\bin\\ffmpeg.exe']

for path in ffmpeg_paths:
    try:
        subprocess.run([path, '-version'], capture_output=True, check=True)
        ffmpeg_cmd = path
        break
    except (subprocess.SubprocessError, FileNotFoundError):
        continue

if ffmpeg_cmd:
    input_pattern = os.path.join(OUTPUT_DIR, "frame_%04d.png").replace('\\', '/')
    output_video = OUTPUT_VIDEO.replace('\\', '/')

    ffmpeg_command = [
        ffmpeg_cmd, '-framerate', str(FRAME_RATE),
        '-i', input_pattern,
        '-vf', 'pad=1920:1062:(ow-iw)/2:(oh-ih)/2',
        '-c:v', 'libx264',
        '-pix_fmt', 'yuv420p',
        '-crf', '18',
        '-y', output_video
    ]

    print(f"Running FFmpeg...")
    try:
        result = subprocess.run(ffmpeg_command, capture_output=True, text=True)
        if result.returncode == 0 and os.path.exists(OUTPUT_VIDEO):
            size_mb = os.path.getsize(OUTPUT_VIDEO) / (1024 * 1024)
            print(f"\nSUCCESS! MP4 created: {OUTPUT_VIDEO}")
            print(f"File size: {size_mb:.2f} MB")
        else:
            print(f"\nFFmpeg failed. Run this command manually:")
            print(f'ffmpeg -framerate {FRAME_RATE} -i "{OUTPUT_DIR}/frame_%04d.png" -vf "pad=1920:1062:(ow-iw)/2:(oh-ih)/2" -c:v libx264 -pix_fmt yuv420p -crf 18 -y {OUTPUT_VIDEO}')
    except Exception as e:
        print(f"\nError: {e}")
        print(f'ffmpeg -framerate {FRAME_RATE} -i "{OUTPUT_DIR}/frame_%04d.png" -vf "pad=1920:1062:(ow-iw)/2:(oh-ih)/2" -c:v libx264 -pix_fmt yuv420p -crf 18 -y {OUTPUT_VIDEO}')
else:
    print("\nFFmpeg not found. Run this command manually:")

2                                                                                                                         Altair SLC

    print(f'ffmpeg -framerate {FRAME_RATE} -i "{OUTPUT_DIR}/frame_%04d.png" -vf "pad=1920:1062:(ow-iw)/2:(oh-ih)/2" -c:v libx264 -pix_fmt yuv420p -crf 18 -y {OUTPUT_VIDEO}')

print("\n" + "=" * 60)
print("PROCESS COMPLETE")
print("=" * 60)
print(f"Animation saved to: {OUTPUT_VIDEO}")
NOTE: 211 records were read from file 'c:\temp\py_pgmx.py'
      The minimum record length was 80
      The maximum record length was 181
NOTE: 211 records were written to file 'c:\temp\py_pgm.py'
      The minimum record length was 80
      The maximum record length was 181
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.015



NOTE: The infile rut is:
      Unnamed Pipe Access Device,
      Process=C:\Progra~1\ParaView-6.1.0-Windows-Python3.12-msvc2017-AMD64\bin\pvpython.exe c:/temp/py_pgm.py 2> c:/temp/py_pgm.log,
      Lrecl=32767, Recfm=V

============================================================
VTKHDF to MP4 Converter with Von Mises Stress
============================================================
Input file: D:/rad/Bumper_Beam_AP_meshed.vtkhdf
Output video: D:/rad/bump_animation.mp4
Frame rate: 30 fps

Loading VTKHDF file...
Found 101 time steps
Point Data: ['NODE_ID']
Cell Data: ['2DELEM_Plastic_Strain', '2DELEM_Strain_(layer__1)_', '2DELEM_Strain_(layer__2)_',
 '2DELEM_Strain_(layer__3)_', '2DELEM_Strain_(layer__4)_', '2DELEM_Strain_(layer__5)_',
 '2DELEM_Strain_(lower)', '2DELEM_Strain_(upper)', '2DELEM_Stress_(layer__
1)_', '2DELEM_Stress_(layer__2)_', '2DELEM_Stress_(layer__3)_', '2DELEM_Stress_(layer__4)_',
 '2DELEM_Stress_(layer__5)_', '2DELEM_Stress_(lower)', '2DELEM_Stress_(upper)',
 '2DELEM_Von_Mises', 'ELEMENT_ID', 'EROSION_STATUS', 'PART_ID']

Converting cell data to point data...
Point Data after conversion: ['NODE_ID', '2DELEM_Plastic_Strain', '2DELEM_Strain_(layer__1)_',
 '2DELEM_Strain_(layer__2)_', '2DELEM_Strain_(layer__3)_', '2DELEM_Strain_(layer__4)_',
 '2DELEM_Strain_(layer__5)_', '2DELEM_Strain_(lower)', '2DELEM_Strain_(upp
er)', '2DELEM_Stress_(layer__1)_', '2DELEM_Stress_(layer__2)_', '2DELEM_Stress_(layer__3)_',
 '2DELEM_Stress_(layer__4)_', '2DELEM_Stress_(layer__5)_', '2DELEM_Stress_(lower)',
 '2DELEM_Stress_(upper)', '2DELEM_Von_Mises', 'ELEMENT_ID', 'EROSION_STATUS', 'P
ART_ID']

Setting up render view...

Applying coloring using '2DELEM_Von_Mises'...
  Data range: 0.000000 to 0.000000
  WARNING: Data range is zero - no variation in data

Saving 101 frames to D:/rad/frames...
  Saved frame 10/101
  Saved frame 20/101
  Saved frame 30/101
  Saved frame 40/101
  Saved frame 50/101
  Saved frame 60/101
  Saved frame 70/101
  Saved frame 80/101
  Saved frame 90/101
  Saved frame 100/101
  Saved frame 101/101

Frames saved to: D:/rad/frames

==================================================
Converting PNG sequence to MP4...
==================================================
Running FFmpeg...

SUCCESS! MP4 created: D:/rad/bump_animation.mp4
File size: 0.14 MB

============================================================
PROCESS COMPLETE
============================================================
Animation saved to: D:/rad/bump_animation.mp4
NOTE: 51 records were written to file PRINT

NOTE: 48 records were read from file rut
      The minimum record length was 0
      The maximum record length was 518
NOTE: The data step took :
      real time : 32.310
      cpu time  : 0.000



NOTE: The infile 'c:\temp\py_pgm.log' is:
      Filename='c:\temp\py_pgm.log',
      Owner Name=SLC\suzie,
      File size (bytes)=114,
      Create Time=11:45:37 May 12 2026,
      Last Accessed=15:48:11 May 26 2026,
      Last Modified=15:48:11 May 26 2026,
      Lrecl=32767, Recfm=V

(   4.365s) [paraview        ]vtkSMColorMapEditorHelp:3204  WARN| Failed to determine the LookupTable being used.
NOTE: 1 record was read from file 'c:\temp\py_pgm.log'
      The minimum record length was 113
      The maximum record length was 113
NOTE: The data step took :
      real time : 0.000
      cpu time  : 0.000


ERROR: Error printed on page 1

NOTE: Submitted statements took :
      real time : 32.500
      cpu time  : 0.093

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
