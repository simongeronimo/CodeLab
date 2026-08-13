package main

import (
	"fmt"
	"os/exec"
	"strings"
)

func main() {
	cmd := exec.Command("fzf")
	list := "alpha\nBeta\nzeta"
	cmd.Stdin = strings.NewReader(list)
	out, _ := cmd.Output()
	var input string
	_, err := fmt.Scanln(&input)
	fmt.Println(string(out))
	if err != nil {
		fmt.Println(err)
	}
}
