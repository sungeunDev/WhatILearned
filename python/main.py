import sys

x = 6
y = 3

print(x+y)


for i in range(len(sys.argv)):
    print "sys.argv[%d] = '%s'" % (i, sys.argv[i])


def crossBridge(steps):
    cnt = 0
    current = 0
    n = len(steps) // 배열의 count
    while (current <= n):
        current += steps[current] #현재 위치
        cnt += 1 #점프 횟수
    return cnt
