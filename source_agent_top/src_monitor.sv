class src_monitor extends uvm_monitor;

        `uvm_component_utils(src_monitor)

        virtual router_if.SRC_MON_MP    vif;
        src_config                      src_cfg;
        src_xtn         xtn;
        uvm_analysis_port#(src_xtn)ap;

        extern function new(string name = "src_monitor", uvm_component parent = null);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task collect_data();

endclass

function src_monitor :: new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap",this);
endfunction:new

function void src_monitor :: build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(src_config)::get(this,"","src_config",src_cfg))
                `uvm_fatal(get_type_name(), "Getting failed in src_monitor")
        xtn = src_xtn :: type_id :: create("xtn");

endfunction:build_phase

function void src_monitor :: connect_phase(uvm_phase phase);
        vif = src_cfg.vif;
endfunction

task src_monitor :: run_phase (uvm_phase phase);
        forever
                begin
                        collect_data();
                        ap.write(xtn);
                end
endtask

task src_monitor :: collect_data();
//      xtn.print();

        @(vif.src_mon_cb);

        while(vif.src_mon_cb.pkt_vld!==1)
                @(vif.src_mon_cb);
        while(vif.src_mon_cb.busy !== 0)
                @(vif.src_mon_cb);
        xtn.header = vif.src_mon_cb.data_in;

        xtn.payload_data = new[xtn.header[7:2]];
        @(vif.src_mon_cb);
        foreach(xtn.payload_data[i])
                begin
                        while(vif.src_mon_cb.pkt_vld !== 1)
                                @(vif.src_mon_cb);
                        while(vif.src_mon_cb.busy !== 0)
                                @(vif.src_mon_cb);
                        xtn.payload_data[i] = vif.src_mon_cb.data_in;
                                @(vif.src_mon_cb);
                end

        while(vif.src_mon_cb.pkt_vld !== 0)
                @(vif.src_mon_cb);

        while(vif.src_mon_cb.busy !== 0)
                @(vif.src_mon_cb);

        xtn.parity <= vif.src_mon_cb.data_in;

        repeat(2)
        @(vif.src_mon_cb);
        xtn.error <= vif.src_mon_cb.error;

        `uvm_info("SRC_MONITOR", $sformatf("Printing from monitor\n%s",xtn.sprint()),UVM_LOW)
endtask
