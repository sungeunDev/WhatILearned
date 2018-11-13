#!/usr/bin/env python3
print('<String>')

print('hello world')
print("hello world\n")
'''
- 큰 따옴표, 작은 따옴표 둘 다 기능은 동일
- 파이썬에서는 '작은 따옴표'를 주로 이용
- 구분은 왜?
    ㄴ 중간에 문자열로 ', "를 쓰고 싶을 때 문자열이 끊기는걸 방지하기 위해서.
    ㄴ ex. 'hell'o'world' 인 경우 invalid syntax.
    ㄴ -> 'hell\'o\'world' 역슬레시를 넣어 '가 문자열로 쓰인다는 것을 표기
    ㄴ ㄴ -> excape sequence
'''

print('<docstring>')
print('''h
e
l
l
o
''')

print('<String Operation>')
a = 'String Operation'
print(a)

print('\n<len>')
print(len(a))

print('\n<index>')
print(a[0])
print(a[2])

print('\n<slicing strings>')
print(a[0:6])

print('\n<repeat>')
print((a+'\n')*2)
print(a+'\n'+a)

print('\n<치환>')
name = 'banana'
print('to '+name+'. Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.')
# todo: apple -> another name

name =  'banana'
