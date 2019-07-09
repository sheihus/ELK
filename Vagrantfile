Vagrant.configure("2") do |config|
    config.vm.box = "sbeliakou/centos"
    config.vm.provider "virtualbox" do |vb|
	vb.memory = "1024"
    end
    
    config.vm.define "tomcat" do |tk| 
	tk.vm.network "private_network", ip: "192.168.56.100"
	tk.vm.hostname = "tomcat"
	tk.vm.provision "file", source: "./TestApp.war", destination: "/home/vagrant/"
	tk.vm.provision "file", source: "./tomcat.service", destination: "/home/vagrant/"
	tk.vm.provision "file", source: "./functions", destination: "/home/vagrant/"
	tk.vm.provision "shell", path: "tomcat.sh"
    end


    config.vm.define "kibana" do |ki| 
	ki.vm.network "private_network", ip: "192.168.56.101"
	ki.vm.hostname = "kibana"
	ki.vm.provision "file", source: "./functions", destination: "/home/vagrant/"
	ki.vm.provision "shell", path: "kibana.sh"
    end
    
end  
