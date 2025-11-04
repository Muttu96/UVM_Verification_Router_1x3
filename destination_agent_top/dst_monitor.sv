class dst_monitor extends uvm_monitor;

        `uvm_component_utils(dst_monitor)
        virtual router_if.DST_MON_MP vif;
        dst_config      dst_cfg;
        dst_xtn xtn;

        uvm_analysis_port#(dst_xtn)ap;


        extern function new(string name = "dst_monitor", uvm_component parent = null);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task collect_data();

endclass


function dst_monitor :: new(string name, uvm_component parent);
        super.new(name, parent);
        ap = new("ap", this);
endfunction:new


function void dst_monitor :: build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(dst_config)::get(this,"","dst_config",dst_cfg))
                `uvm_fatal(get_full_name(),"Getting failed in dst_monitor")
        xtn = dst_xtn :: type_id :: create("xtn");

endfunction:build_phase

function void dst_monitor :: connect_phase(uvm_phase phase);
        vif = dst_cfg.vif;
endfunction

task dst_monitor :: run_phase (uvm_phase phase);
        forever
                begin
                        collect_data();
                        ap.write(xtn);
                end
endtask
task dst_monitor :: collect_data();

//      @(vif.dst_mon_cb);

//        while(vif.dst_mon_cb.vld_out == 1)
//              @(vif.dst_mon_cb);
//      repeat(2)
        @(vif.dst_mon_cb);
        while(vif.dst_mon_cb.read_enb !== 1)
                @(vif.dst_mon_cb);

        repeat(2)
        @(vif.dst_mon_cb);
        xtn.header = vif.dst_mon_cb.data_out;

        xtn.payload_data = new[xtn.header[7:2]];

        @(vif.dst_mon_cb);
        foreach(xtn.payload_data[i])
                begin
                //      while(vif.dst_mon_cb.vld_out == 1)
                //              @(vif.dst_mon_cb);
                        while(vif.dst_mon_cb.read_enb !== 1)
                                @(vif.dst_mon_cb);
                        xtn.payload_data[i] = vif.dst_mon_cb.data_out;
                                @(vif.dst_mon_cb);
                end

//      while(vif.dst_mon_cb.vld_out == 1)
//              @(vif.dst_mon_cb);

        while(vif.dst_mon_cb.read_enb !== 1)
                @(vif.dst_mon_cb);

        xtn.parity = vif.dst_mon_cb.data_out;

        `uvm_info("DST_MONITOR", $sformatf("Printing from monitor\n%s",xtn.sprint()),UVM_LOW)

endtask
