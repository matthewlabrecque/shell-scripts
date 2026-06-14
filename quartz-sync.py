import os
import shutil

def update_directory(src_dir, dst_dir, exclude_func):
    for root, dirs, files in os.walk(src_dir):
        dirs[:] = [d for d in dirs if not exclude_func(d)]
        
        rel_path = os.path.relpath(root, src_dir)
        dst_root = os.path.join(dst_dir, rel_path)
        os.makedirs(dst_root, exist_ok=True)

        for file in files:
            if exclude_func(file):
                continue

            src_file = os.path.join(root, file)

            ### Here is where we have to do our language processing

            dst_file = os.path.join(dst_root, file)

            try:
                src_mtime = os.path.getmtime(src_file)
                dst_mtime = os.path.getmtime(dst_file)
                
                if src_mtime > dst_mtime:
                    shutil.copy2(src_file, dst_file)
            except FileNotFoundError:
                shutil.copy2(src_file, dst_file)
            except OSError:
                continue

def main():
    SOURCE = '/home/mlab/zettelkasten'
    DEST = '/home/mlab/Projects/digitalgarden/content'
    
    def is_excluded(item_name):
        return item_name in ['.git', 'daily-notes', 'templates', 'PRIVATE']
    
    update_directory(SOURCE, DEST, is_excluded)

if __name__ == "__main__":
    main()
