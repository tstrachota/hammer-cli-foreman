require_relative '../test_helper'

describe 'compute-attributes info' do
  def profile_data(provider_name = nil)
    profile = load_json('./data/profile_info.json', __FILE__)
    profile['compute_attributes'] = [
      load_json("./data/#{provider_name}_attrs.json", __FILE__)
    ] if provider_name
    profile
  end

  def api_expects_profile_show(provider_name = nil)
    api_expects(:compute_profiles, :show, 'Get compute profile info')
      .with_params('id' => '1')
      .returns(profile_data(provider_name))
  end

  let(:cmd) { %w(compute-profile info --id=1) }

  it 'prints name and id' do
    api_expects_profile_show

    output = OutputMatcher.new([
      "Id:                 1",
      "Name:               1-Small",
      "Compute attributes: "
    ])

    expected_result = success_result(output)
    assert_cmd(expected_result, run_cmd(cmd))
  end

  it 'formats attributes for libvirt' do
    api_expects_profile_show(:libvirt)

    output = OutputMatcher.new([
      "Id:                 1",
      "Name:               1-Small",
      "Compute attributes: ",
      " 1) tstracho-laptop (Libvirt)",
      "    Name:          1 CPUs and 1 GB memory",
      "    VM attributes: ",
      "        CPUs:               1",
      "        Memory:             1 GB",
      "        Network interfaces: ",
      "         1) Type:    bridge",
      "            Network: br0",
      "            Model:   virtio",
      "         2) Type:    network",
      "            Network: default",
      "            Model:   virtio",
      "        Storage:            ",
      "         1) Storage pool: default",
      "            Size:         10 GB",
      "            Allocation:   0 GB",
      "            Format:       qcow2"
    ])

    expected_result = success_result(output)
    assert_cmd(expected_result, run_cmd(cmd))
  end

  it 'formats attributes for ec2' do
    api_expects_profile_show(:ec2)

    output = OutputMatcher.new([
      "Compute attributes: ",
      " 1) EC2 (EC2)",
      "    Name:          t2.micro - Micro Instance",
      "    VM attributes:",
      "        Flavor:            Micro Instance",
      "        Image:             RHEL73",
      "        Availability zone: us-east-1b",
      "        Security groups:",
      "         1)",
      "        Managed IP:        private"
    ])

    expected_result = success_result(output)
    assert_cmd(expected_result, run_cmd(cmd))
  end

  it 'formats attributes for vmware' do
    api_expects_profile_show(:vmware)

    output = OutputMatcher.new([
      "Compute attributes: ",
      " 1) vmWare (VMware)",
      "    Name:          2 CPUs and 768 MB memory",
      "    VM attributes:",
      "        CPUs:                2",
      "        Cores per socket:    1",
      "        Memory:              768 KB",
      "        Firmware:            bios",
      "        Cluster:             Foreman_Engineering",
      "        Resource pool:       Resources",
      "        Folder:              Test",
      "        Guest OS:            Other Operating System (64-bit)",
      "        Virtual H/W version: 9 (ESXi 5.1)",
      "        Memory hot add:      yes",
      "        CPU hot add:         yes",
      "        CD-ROM drive:        no",
      "        Annotation Notes:",
      "        Network interfaces:",
      "         1) Type:    E1000",
      "            Network: EngRef_Network",
      "         2) Type:    VMXNET 3",
      "            Network: Private_Networks-DVUplinks-25",
      "        Storage:",
      "         1) SCSI controller: VirtualLsiLogicController",
      "            Volumes:",
      "             1) Disk name:      Hard disk",
      "                Data store:     Local-Jericho",
      "                Disk mode:      persistent",
      "                Size:           10 GB",
      "                Thin provision: yes",
      "                Eager zero:     no",
      "             2) Disk name:      Hard disk",
      "                Data store:     Local-Bulgaria",
      "                Disk mode:      persistent",
      "                Size:           10 GB",
      "                Thin provision: no",
      "                Eager zero:     no",
      "         2) SCSI controller: VirtualLsiLogicController",
      "            Volumes:",
      "             1) Disk name:      Hard disk",
      "                Disk mode:      persistent",
      "                Size:           10 GB",
      "                Thin provision: no",
      "                Eager zero:     no"
    ])

    expected_result = success_result(output)
    assert_cmd(expected_result, run_cmd(cmd))
  end

  it 'formats attributes for vmware with details' do
    api_expects_profile_show(:vmware)

    output = OutputMatcher.new([
      "Compute attributes: ",
      " 1) vmWare (id: 6, VMware)",
      "    Id:            12",
      "    Name:          2 CPUs and 768 MB memory",
      "    VM attributes:",
      "        CPUs:                2",
      "        Cores per socket:    1",
      "        Memory:              768 KB",
      "        Firmware:            bios",
      "        Cluster:             Foreman_Engineering (id: domain-c7)",
      "        Resource pool:       Resources (id: resgroup-8)",
      "        Folder:              Test (id: /Datacenters/Engineering/Test)",
      "        Guest OS:            Other Operating System (64-bit) (id: otherGuest64)",
      "        Virtual H/W version: 9 (ESXi 5.1) (id: vmx-09)",
      "        Memory hot add:      yes",
      "        CPU hot add:         yes",
      "        CD-ROM drive:        no",
      "        Annotation Notes:",
      "        Network interfaces:",
      "         1) Type:    E1000 (id: VirtualE1000)",
      "            Network: EngRef_Network (id: dvportgroup-125)",
      "         2) Type:    VMXNET 3 (id: VirtualVmxnet3)",
      "            Network: Private_Networks-DVUplinks-25 (id: dvportgroup-26)",
      "        Storage:",
      "         1) SCSI controller: VirtualLsiLogicController",
      "            Volumes:",
      "             1) Disk name:      Hard disk",
      "                Data store:     Local-Jericho (id: datastore-48)",
      "                Disk mode:      persistent",
      "                Size:           10 GB",
      "                Thin provision: yes",
      "                Eager zero:     no",
      "             2) Disk name:      Hard disk",
      "                Data store:     Local-Bulgaria (id: datastore-65)",
      "                Disk mode:      persistent",
      "                Size:           10 GB",
      "                Thin provision: no",
      "                Eager zero:     no",
      "         2) SCSI controller: VirtualLsiLogicController",
      "            Volumes:",
      "             1) Disk name:      Hard disk",
      "                Disk mode:      persistent",
      "                Size:           10 GB",
      "                Thin provision: no",
      "                Eager zero:     no"
    ])

    expected_result = success_result(output)
    assert_cmd(expected_result, run_cmd(cmd, :show_ids => true))
  end

  it 'formats attributes for gce' do
    api_expects_profile_show(:gce)

    output = OutputMatcher.new([
      "Compute attributes: ",
      " 1) GCE (Google)",
      "    Name:          f1-micro",
      "    VM attributes:",
      "        Machine type: f1-micro",
      "        Network:      default",
      "        External IP:  yes",
      "        Storage:",
      "         1) Size: 10 GB",
      "         2) Size: 15 GB",
      "         3) Size: 5 GB"
    ])

    expected_result = success_result(output)
    assert_cmd(expected_result, run_cmd(cmd))
  end

  it 'formats attributes for openstack' do
    api_expects_profile_show(:openstack)

    output = OutputMatcher.new([
      "Compute attributes: ",
      " 1) Try OpenStack (OpenStack)",
      "    Name:          m1.tiny",
      "    VM attributes:",
      "        Flavor:                m1.tiny",
      "        Availability zone:",
      "        Image:                 Test image",
      "        Tenant:                test_tenant",
      "        Security group:        default",
      "        Network interfaces:",
      "         1) public",
      "        Floating IP network:   public",
      "        Boot from volume:      yes",
      "        New boot volume size:  12 GB",
      "        Scheduler hint filter:"
    ])

    expected_result = success_result(output)
    assert_cmd(expected_result, run_cmd(cmd))
  end

  it 'formats attributes for rackspace' do
    api_expects_profile_show(:rackspace)

    output = OutputMatcher.new([
      "Compute attributes: ",
      " 1) Fake Rackspace (Rackspace)",
      "    Name:          512MB Standard Instance",
      "    VM attributes:",
      "        Flavor: 512MB Standard Instance"
    ])

    expected_result = success_result(output)
    assert_cmd(expected_result, run_cmd(cmd))
  end

  it 'formats attributes for ovirt' do
    api_expects_profile_show(:ovirt)

    output = OutputMatcher.new([
      "Compute attributes: ",
      " 1) Test oVirt (oVirt)",
      "    Name:          2 Cores and 512 MB memory",
      "    VM attributes:",
      "        Cluster:            Cluster2",
      "        Template:           hwp_large",
      "        Cores:              2",
      "        Memory:             512 MB",
      "        Network interfaces:",
      "         1) Name: eth0",
      "         2) Name: eth1",
      "        Storage:",
      "         1) Size:             15 GB",
      "            Storage domain:   nfs",
      "            Preallocate disk: no",
      "            Bootable:         no",
      "         2) Size:             5 GB",
      "            Storage domain:   covirt",
      "            Preallocate disk: yes",
      "            Bootable:         yes"
    ])

    expected_result = success_result(output)
    assert_cmd(expected_result, run_cmd(cmd))
  end

  it 'formats attributes for providers without param definition' do
    api_expects_profile_show(:unknown)

    output = OutputMatcher.new([
      "Compute attributes: ",
      " 1) Unknown resource (Fake)",
      "    Name:          t2.micro - Micro Instance",
      "    VM attributes:",
      "        Attributes:",
      "          flavor_id: t2.micro",
      "          flavor_name: Micro Instance",
      "          image_id: ami-b63769a1",
      "          image_name: RHEL73",
      "          security_groups:",
      "            '0':",
      "              id: sg-379ac25f",
      "              name: default",
      "            '1':",
      "              id: sg-1a85fba2",
      "              name: group 1",
      "        Network interfaces:",
      "         1) Attributes:",
      "              type: bridge",
      "              bridge: br0",
      "              model: virtio",
      "         2) Attributes:",
      "              type: network",
      "              network: default",
      "              model: virtio",
      "        Storage:",
      "         1) Attributes:",
      "              capacity: '10737418240'",
      "              allocation: '0'",
      "              format_type: qcow2",
      "              pool: default"
    ])

    expected_result = success_result(output)
    assert_cmd(expected_result, run_cmd(cmd))
  end
end
