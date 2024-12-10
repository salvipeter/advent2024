package main

import "fmt"

func step(i, j, dir int) bool {
	h := data[i][j] + 1
	switch dir {
	case 0:
		return i > 0 && data[i-1][j] == h
	case 1:
		return i < len(data) - 1 && data[i+1][j] == h
	case 2:
		return j > 0 && data[i][j-1] == h
	case 3:
		return j < len(data[0]) - 1 && data[i][j+1] == h
	}
	return false
}

func hike(i, j int, distinct bool) int {
	count := 0
	width := len(data[0])
	height := len(data)
	next := []int{-width, width, -1, 1}
	reached := make([]bool, width * height)
	queue := []int{i * width + j}
	for len(queue) > 0 {
		index := queue[0]
		queue = queue[1:]
		adjacent := []int{}
		i, j := index / width, index % width
		for d := 0; d < 4; d++ {
			if step(i, j, d) {
				adjacent = append(adjacent, index + next[d])
			}
		}
		for _, k := range(adjacent) {
			if distinct || !reached[k] {
				reached[k] = true
				if data[k/width][k%width] == 9 {
					count++
				} else {
					queue = append(queue, k)
				}
			}
		}
	}
	return count
}

func main() {
	peaks, trails := 0, 0
	for i := range(data) {
		for j := range(data[i]) {
			if data[i][j] == 0 {
				peaks += hike(i, j, false)
				trails += hike(i, j, true)
			}
		}
	}
	fmt.Printf("%v\n%v\n", peaks, trails)
}
