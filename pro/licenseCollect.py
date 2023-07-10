import sys
import os
import glob
import shutil

looking_for = ['COPYING', 'LICENSE', 'LICENCE', 'COPYRIGHT']
name_not = ['TagLicenseFlags.cs']
path_not_contain = [r'gst-libs\gst\tag\license', "gst-libs/gst/tag/license", r"\src\tools\no-copyright", "/src/tools/no-copyright"]

in_dir = sys.argv[1]
out_dir = sys.argv[2]

in_dir = os.path.realpath(in_dir)
out_dir = os.path.realpath(out_dir)

print("Looking dir:", in_dir)
print("Licenses dir:", out_dir)

def is_license(file_path):
    for target in path_not_contain:
        if target.upper() in file_path.upper():
            return False

    filename = os.path.basename(file_path)

    for target in name_not:
        if target.upper() == filename.upper():
            return False

    for target in looking_for:
        if target.upper() in filename.upper():
            return True
    return False

def scan_dir(dir_path):
    for item in glob.glob(dir_path+"/*"):
        if os.path.isdir(item):
           scan_dir(item)
        elif os.path.isfile(item):
            if is_license(item):
                src_file = os.path.realpath(item)
                filename = os.path.basename(src_file)
                dirname = os.path.dirname(os.path.realpath(src_file))
                dst_subdir = dirname[len(in_dir):]
                dst_dir = os.path.realpath(out_dir+"/"+dst_subdir)
                dst_file = os.path.realpath(dst_dir+"/"+filename)
                os.makedirs(dst_dir, exist_ok=True)
                shutil.copyfile(src_file, dst_file)
                print(dst_file)


scan_dir(in_dir)
