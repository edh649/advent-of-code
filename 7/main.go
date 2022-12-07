package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
	"strings"
)

func main() {
	var err error
	file := OpenFile("input.txt")
	//close the file when done..? messy but fine.
	defer func() { //Defer means it only runs when the function is returned.. interesting
		if err = file.Close(); err != nil {
			log.Fatal(err)
		}
	}()

	result := Parsefile(file)

	fmt.Println("Directories under 100000 and smallest directory to free up " + result)
}

func GetPath() string {
	path, err := os.Getwd() //https://yourbasic.org/golang/current-directory/
	if err != nil {
		log.Println(err)
	}
	return path
}

func OpenFile(filepath string) *os.File { //https://stackoverflow.com/questions/36111777/how-to-read-a-text-file
	file, err := os.Open(filepath)
	if err != nil {
		log.Fatal(err)
	}

	return file
}

func Parsefile(file *os.File) string { //asterisk means passed by pointer!
	scanner := bufio.NewScanner(file)

	fileSizeList := make(map[string]int)
	var directoryList []string

	var activeDirectory = ""
	for scanner.Scan() { // internally, it advances token based on sperator (new line by default)
		r := scanner.Text() + "             " //cheap hack to stop overflows

		if r[0:5] == "$ cd " {
			directory := strings.Trim(r[5:], " ")
			if directory == ".." {
				lastDirIndex := strings.LastIndex(activeDirectory, "/")
				activeDirectory = activeDirectory[0:lastDirIndex]
			} else if directory == "/" {
				activeDirectory = ""
			} else {
				activeDirectory = activeDirectory + "/" + directory
				directoryList = append(directoryList, activeDirectory)
			}
		} else if r[0:4] == "$ ls" {
			//do nothing (ls is pointless)
		} else if r[0:1] == "$" {
			log.Fatal("Unexpected terminal command...")
		} else if r[0:3] == "dir" {
			//do nothing (don't care about dirs)
		} else {
			sizeFileSplit := strings.Split(strings.Trim(r, " "), " ")
			fileSize, err := strconv.Atoi(sizeFileSplit[0])
			if err != nil {
				log.Fatal("Unexpected non-numeric file size")
			}
			fileLocation := activeDirectory + "/" + sizeFileSplit[1]
			fileSizeList[fileLocation] = fileSize
		}
	}

	totalDiskSpace := 70000000
	totalUsedSpace := GetDirectorySize("/", fileSizeList)
	totalSpaceRequired := 30000000
	totalSizeFree := totalDiskSpace - totalUsedSpace
	totalSizeToFree := totalSpaceRequired - totalSizeFree

	// prunableDirectoryList := make(map[string]int)
	totalPrunableSize := 0
	smallestPrunableDirectory := totalDiskSpace
	for _, v := range directoryList {
		size := GetDirectorySize(v, fileSizeList)
		if size <= 100000 {
			// prunableDirectoryList[v] = size
			totalPrunableSize = totalPrunableSize + size
		}
		if size < smallestPrunableDirectory && size > totalSizeToFree {
			smallestPrunableDirectory = size
		}
	}

	return strconv.Itoa(totalPrunableSize) + ", " + strconv.Itoa(smallestPrunableDirectory)
}

func GetDirectorySize(directory string, files map[string]int) int {
	size := 0
	for k, v := range files {
		if len(k) < len(directory) {
			continue
		}
		if k[:len(directory)] == directory {
			size = size + v
		}
	}
	return size
}
