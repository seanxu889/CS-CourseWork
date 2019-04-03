# -*- coding: utf-8 -*-
import time
from random import choice
import copy
import heapq


# the heruistic distance
def distance(matrix):
    cur_pos = []
    target_pos = []
    for i in range(len(matrix)):
        for j in range(len(matrix[i])):
            if matrix[i][j] == 2:
                cur_pos.append([i, j])
            if matrix[i][j] == -1:
                target_pos.append([i, j])
    result = 0
    for i in cur_pos:
        for j in target_pos:
            result += (abs(i[0] - j[0]) + abs(i[1] - j[1]))

    return result


class Node:
    def __init__(self, matrix, p=None, m=None):
        self.matrix = matrix
        self.p = p
        self.m = m

    def __int__(self):
        return distance(self.matrix)

    def __lt__(self, other):
        return distance(self.matrix) < distance(other.matrix)

    def __repr__(self):
        height = self.matrix
        i = self.p
        print(i, height)


class Puzzle:
    def loadGame(self, filename):
        with open(filename, 'r') as fp:
            line = fp.readline().strip().split(",")
            width, height = int(line[0]), int(line[1])
            result = [[0 for _ in range(width)] for _ in range(height)]
            for i in range(height):
                line = fp.readline().strip().split(",")
                for j in range(width):
                    result[i][j] = int(line[j])
        return result

    def display(self, matrix):
        width, height = len(matrix[0]), len(matrix)
        print(str(width) + "," + str(height))
        for i in range(height):
            for j in range(width):
                print str(matrix[i][j])+",",
            print

    def clone(self, matrix):
        return copy.deepcopy(matrix)

    def puzzleComplete(self, matrix):
        width, height = len(matrix[0]), len(matrix)
        for i in range(height):
            for j in range(width):
                if matrix[i][j] == -1:
                    return False
        return True

    def matrixCompare(self, matrix1, matrix2):
        width, height = len(matrix1[0]), len(matrix1)
        if width != len(matrix2[0]) or height != len(matrix2):
            return False
        else:
            for i in range(height):
                for j in range(width):
                    if matrix1[i][j] != matrix2[i][j]:
                        return False
        return True

    def normalize(self, matrix):
        matrix = self.clone(matrix)
        nextIdx = 3
        width, height = len(matrix[0]), len(matrix)
        for i in range(height):
            for j in range(width):
                if matrix[i][j] == nextIdx:
                    nextIdx += 1
                elif matrix[i][j] > nextIdx:
                    self.swapIdx(matrix, matrix[i][j], nextIdx)
                    nextIdx += 1
        return matrix

    def swapIdx(self, matrix, idx1, idx2):
        width, height = len(matrix[0]), len(matrix)
        for i in range(height):
            for j in range(width):
                if matrix[i][j] == idx1:
                    matrix[i][j] = idx2
                elif matrix[i][j] == idx2:
                    matrix[i][j] = idx1


def printMove(move):
    if move[1] == "r":
        print("({0},right)".format(move[0]))
    elif move[1] == "l":
        print("({0},left)".format(move[0]))
    elif move[1] == "u":
        print("({0},up)".format(move[0]))
    else:
        print("({0},down)".format(move[0]))


def getLocation(matrix, p):
    width = len(matrix[0])
    height = len(matrix)
    locs = []
    for i in range(height):
        for j in range(width):
            if matrix[i][j] == p:
                locs.append([i, j])
    return [locs[0], locs[-1][1] - locs[0][1] + 1, locs[-1][0] - locs[0][0] + 1]


def checkDirection(matrix, i, j, size, direction):
    neighbour = {"l": "matrix[i + x][j - 1]",
                 "r": "matrix[i - x][j + 1]",
                 "u": "matrix[i - 1][j + x]",
                 "d": "matrix[i + 1][j - x]"}
    if matrix[i][j] == 2:
        nodeType = 0
        for x in range(size):
            if eval(neighbour[direction]) == -1:
                cur = -1
                if nodeType == 0:
                    nodeType = -1
                elif cur != nodeType:
                    return False
            elif eval(neighbour[direction]) == 0:
                cur = 1
                if nodeType == 0:
                    nodeType = 1
                elif cur != nodeType:
                    return False
            else:
                return False
    else:
        for x in range(size):
            if eval(neighbour[direction]) != 0:
                return False
    return True


def pieceAllMove(matrix, p):
    locs = getLocation(matrix, p)
    result = []
    if checkDirection(matrix, locs[0][0], locs[0][1], locs[2], "l"):
        result.append("l")
    if checkDirection(matrix, locs[0][0] + locs[2] - 1, locs[0][1] + locs[1] - 1, locs[2], "r"):
        result.append("r")
    if checkDirection(matrix, locs[0][0], locs[0][1], locs[1], "u"):
        result.append("u")
    if checkDirection(matrix, locs[0][0] + locs[2] - 1, locs[0][1] + locs[1] - 1, locs[1], "d"):
        result.append("d")
    return result


def allMove(matrix):
    result = []
    height = len(matrix)
    width = len(matrix[0])
    maxidx = 1
    for i in range(height):
        for j in range(width):
            if maxidx < matrix[i][j]:
                maxidx = matrix[i][j]
    for i in range(2, maxidx + 1):
        pieceMoves = pieceAllMove(matrix, i)
        for j in range(len(pieceMoves)):
            result.append((i, pieceMoves[j]))
    return result


def applyMove(matrix, m):
    [topLeft, width, height] = getLocation(matrix, m[0])
    i = topLeft[0]
    j = topLeft[1]
    if m[1] in pieceAllMove(matrix, m[0]):
        if m[1] == "l":
            for x in range(height):
                matrix[i + x][j - 1], matrix[i + x][j + width - 1] = m[0], 0
        elif m[1] == "r":
            for x in range(height):
                matrix[i + x][j + width], matrix[i + x][j] = m[0], 0
        elif m[1] == "u":
            for x in range(width):
                matrix[i - 1][j + x], matrix[i + height - 1][j + x] = m[0], 0
        else:
            for x in range(width):
                matrix[i + height][j + x], matrix[i][j + x] = m[0], 0
    else:
        print("Cannot move")
    return matrix


def applyMovingCloning(matrix, m):
    puzzle = Puzzle()
    matrix = puzzle.clone(matrix)
    return applyMove(matrix, m)


def randomWalks(matrix, number):
    puzzle = Puzzle()
    puzzle.display(matrix)
    print
    while (number):
        move = choice(allMove(matrix))
        applyMove(matrix, move)
        printMove(move)
        print
        puzzle.display(matrix)
        print
        if puzzle.puzzleComplete(matrix):
            print("Move {0} times".format(number))
            return
        number -= 1
    return



def bfs(matrix):
    start = time.clock()

    puzzle = Puzzle()
    bfsQueue = []
    visited = []
    bfsQueue.append(Node(matrix))
    visited.append(matrix)
    while len(bfsQueue) > 0:
        curNode = bfsQueue.pop(0)
        if puzzle.puzzleComplete(curNode.matrix):
            current = curNode
            lst = []
            while current.p != None:
                lst.append(current.m)
                current = current.p
            path_length = len(lst)
            while lst:
                a = lst.pop()
                printMove(a)
            puzzle.display(curNode.matrix)
            elapse = time.clock() - start
            print("{0} {1} {2}".format(len(visited), elapse, path_length))
            return curNode
        else:

            for i in allMove(curNode.matrix):
                cur = applyMovingCloning(curNode.matrix, i)
                t = puzzle.normalize(cur)
                if t not in visited:
                    cur = Node(cur, curNode, i)
                    bfsQueue.append(cur)
                    visited.append(t)
    print("Cannot reach the goal!")


def dfs(matrix):
    start = time.clock()

    puzzle = Puzzle()
    dfs_stack = []
    visited = []
    dfs_stack.append(Node(matrix))
    visited.append(matrix)
    while len(dfs_stack) > 0:
        curNode = dfs_stack[-1]
        if puzzle.puzzleComplete(curNode.matrix):
            current = curNode
            dirLst = []
            while current.p != None:
                dirLst.append(current.m)
                current = current.p

            path_length = len(dirLst)
            while dirLst:
                printMove(dirLst.pop())
            puzzle.display(curNode.matrix)
            elapse = time.clock() - start
            print("{0} {1} {2}".format(len(visited), elapse, path_length))
            return curNode
        else:
            hasNodeUnvisited = 0
            for m in allMove(curNode.matrix):
                cur = applyMovingCloning(curNode.matrix, m)
                t = puzzle.normalize(cur)
                if t not in visited:
                    dfs_stack.append(Node(cur, curNode, m))
                    visited.append(t)
                    hasNodeUnvisited = 1
                    break
            if hasNodeUnvisited == 0:
                dfs_stack.pop()
    print("Cannot reach the goal!")


def ids(matrix, maxDepth):
    start = time.clock()
    puzzle = Puzzle()
    for i in range(1, maxDepth):
        lst = dls(matrix, i)
        if lst is None:
            continue
        else:
            found = lst[0]
            expNodes = lst[1]
        current = found
        dirLst = []
        while current.p != None:
            dirLst.append(current.m)
            current = current.p
        path_length = len(dirLst)
        while dirLst:
            printMove(dirLst.pop())
        puzzle.display(found.matrix)
        elapse = time.clock() - start
        print("{0} {1} {2}".format(expNodes, elapse, path_length))
        return found
    print("Cannot reach the goal")


def dls(matrix, depth):
    puzzle = Puzzle()

    dfs_stack = []
    visited = []
    dfs_stack.append(Node(matrix))
    visited.append(matrix)
    number = 0
    while len(dfs_stack) > 0:
        number += 1
        curNode = dfs_stack[-1]
        if puzzle.puzzleComplete(curNode.matrix):
            return [curNode, len(visited)]
        else:
            havNodeUnvisited = 0
            dirLst = allMove(curNode.matrix)
            for m in dirLst:
                cur = applyMovingCloning(curNode.matrix, m)
                t = puzzle.normalize(cur)
                if t not in visited:
                    dfs_stack.append(Node(cur, curNode, m))
                    visited.append(t)
                    havNodeUnvisited = 1
                    break
            if number == depth or havNodeUnvisited == 0:
                dfs_stack.pop()
                number -= 1


def a_star(matrix):
    start = time.clock()

    puzzle = Puzzle()
    priorityQueue = []
    heapq.heapify(priorityQueue)
    visited = []
    heapq.heappush(priorityQueue, Node(matrix))
    visited.append(matrix)
    while len(priorityQueue) > 0:
        curNode = heapq.heappop(priorityQueue)
        if puzzle.puzzleComplete(curNode.matrix):
            current = curNode
            lst = []
            while current.p != None:
                lst.append(current.m)
                current = current.p
            path_length = len(lst)
            while lst:
                a = lst.pop()
                printMove(a)
            puzzle.display(curNode.matrix)
            elapse = time.clock() - start
            print("{0} {1} {2}".format(len(visited), elapse, path_length))
            return curNode
        else:

            for i in allMove(curNode.matrix):
                cur = applyMovingCloning(curNode.matrix, i)
                t = puzzle.normalize(cur)
                if t not in visited:
                    cur = Node(cur, curNode, i)
                    heapq.heappush(priorityQueue, cur)
                    visited.append(t)
    print("Cannot reach the goal!")


def main():
    puzzle = Puzzle()
    matrix = puzzle.loadGame("./SBP-level0.txt")
    matrix1 = puzzle.loadGame("./SBP-level1.txt")
    distance(matrix1)
    randomWalks(matrix, 3)
    print("Breadth-first Search:")
    bfs(matrix1)
    print
    print("Depth-first Search.:")
    dfs(matrix1)
    print
    print("Iterative deepening Search: ")
    ids(matrix1, 1000000)
    print 
    print("A-star Search: ")
    a_star(matrix1)


if __name__ == "__main__":
    main()
