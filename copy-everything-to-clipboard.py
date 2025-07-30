import os
import pyperclip

# Directories to exclude (common generated/boilerplate folders)
EXCLUDED_DIRS = {
    '.git', '.dart_tool', '.idea', '.vscode', 'build',
    'linux', 'macos', 'windows', 'test', 'web', '.fvm'
}

# Allowed extensions
ALLOWED_EXTENSIONS = {'.dart', '.yaml', '.yml'}


def should_exclude(path):
    parts = path.split(os.sep)
    return any(part in EXCLUDED_DIRS for part in parts)


def collect_selected_files(base_dir):
    file_contents = []

    for root, dirs, files in os.walk(base_dir):
        # Remove excluded directories from traversal
        dirs[:] = [d for d in dirs if d not in EXCLUDED_DIRS]

        for file in files:
            ext = os.path.splitext(file)[1]
            if ext not in ALLOWED_EXTENSIONS:
                continue

            full_path = os.path.join(root, file)
            if should_exclude(full_path):
                continue

            try:
                with open(full_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    relative_path = os.path.relpath(full_path, base_dir)
                    file_contents.append(
                        f"--- FILE: {relative_path} ---\n{content}\n")
            except Exception as e:
                file_contents.append(
                    f"--- FILE: {relative_path} ---\n<Could not read file: {e}>\n")

    return "\n".join(file_contents)


def main():
    base_dir = os.getcwd()  # You can replace this with a specific path
    data = collect_selected_files(base_dir)

    try:
        pyperclip.copy(data)
        print("✅ Only .dart and .yaml/.yml files copied to clipboard.")
    except pyperclip.PyperclipException as e:
        print("❌ Failed to copy to clipboard. Error:", e)


if __name__ == "__main__":
    main()
