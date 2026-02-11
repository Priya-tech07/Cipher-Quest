
import re

def check_braces(filename):
    print(f"Checking {filename}")
    with open(filename, 'r') as f:
        content = f.read()
    
    opens = content.count('{')
    closes = content.count('}')
    print(f"Global - {{: {opens}, }}: {closes}")
    
    stack = []
    lines = content.split('\n')
    for line_num, line in enumerate(lines, 1):
        for char in line:
            if char == '{':
                stack.append(line_num)
            elif char == '}':
                if not stack:
                    print(f"Line {line_num}: Extra }}")
                else:
                    stack.pop()
    
    if stack:
        print(f"Unclosed {{ at lines: {stack}")
    else:
        print("All braces balanced!")

    print("Starting check...")
    check_braces("/Users/apple/Desktop/iMac14/My App copy 2.swiftpm/CipherQuest/Views/Profile/RiddleGridView.swift")
