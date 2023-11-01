package src

import (
	"fmt"
	"net"
)

func PrintLocalIp() {
	interfaces, err := net.Interfaces()
	if err != nil {
		fmt.Println("Error getting network interfaces:", err)
	}

	for _, iface := range interfaces {
		addrs, err := iface.Addrs()
		if err != nil {
			fmt.Println("Error getting interface addresses:", iface.Name, err)
			continue
		}

		for _, addr := range addrs {
			var ip net.IP
			switch v := addr.(type) {
			case *net.IPNet:
				ip = v.IP
			case *net.IPAddr:
				ip = v.IP
			}

			if ip == nil || ip.IsLoopback() {
				continue
			}

			if ip.To4() != nil {
				fmt.Println("Local IPv4-address:", ip.String())
			} else {
				// fmt.Println("Local IPv6-address:", ip.String())
			}
		}
	}
}
