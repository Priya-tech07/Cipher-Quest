import sys

def check_visual_view(filename):
    with open(filename, 'r') as f:
        content = f.read()
    
    lines = content.split('\n')
    start_line = -1
    for i, line in enumerate(lines):
        if 'struct TutorialVisualView: View {' in line:
            start_line = i
            break
    
    if start_line == -1:
        print("TutorialVisualView not found")
        return

    level = 0
    for i in range(start_line, len(lines)):
        line = lines[i]
        line_num = i + 1
        
        level += line.count('{')
        level -= line.count('}')
        
        # print(f"{line_num:4} | {level:2} | {line}")
        
        if level == 0:
            print(f"--- Struct closed at line {line_num} ---")
            break
    else:
        print(f"Struct NEVER closed. Final level: {level}")

check_visual_view("/Users/apple/Desktop/iMac14/My App copy 2.swiftpm/CipherQuest/Views/Components/CipherTutorialView.swift")
