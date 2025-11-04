class src_driver extends uvm_driver#(src_xtn);

        `uvm_component_utils(src_driver)

        virtual router_if.SRC_DRV_MP    vif;
        src_config                      src_cfg;

        extern function new(string name = "src_driver", uvm_component parent = null);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern function void end_of_elaboration_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task send_to_dut(src_xtn req);

endclass


function src_driver :: new(string name, uvm_component parent);
        super.new(name, parent);
endfunction:new


function void src_driver :: build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(src_config)::get(this,"","src_config",src_cfg))
                `uvm_fatal(get_type_name(),"Getting failed in src_drv")

endfunction:build_phase

function void src_driver :: end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology;
endfunction:end_of_elaboration_phase

function void src_driver :: connect_phase(uvm_phase phase);
        vif = src_cfg.vif;
endfunction

task src_driver :: run_phase(uvm_phase phase);
        @(vif.src_drv_cb);
                vif.src_drv_cb.rstn <= 1'b0;
        @(vif.src_drv_cb);
                vif.src_drv_cb.rstn <= 1'b1;

        forever
                begin
                        seq_item_port.get_next_item(req);
                        send_to_dut(req);
                        seq_item_port.item_done();
                end
endtask:run_phase


task src_driver :: send_to_dut(src_xtn req);

        @(vif.src_drv_cb);
        while(vif.src_drv_cb.busy !==0)
                @(vif.src_drv_cb);

        vif.src_drv_cb.pkt_vld <= 1;
        vif.src_drv_cb.data_in <= req.header;
                @(vif.src_drv_cb);

        foreach(req.payload_data[i])
                begin
                        while(vif.src_drv_cb.busy !== 0)
                                @(vif.src_drv_cb);
                        vif.src_drv_cb.data_in <= req.payload_data[i];
                        @(vif.src_drv_cb);
                end
                vif.src_drv_cb.pkt_vld <= 1'b0;

                while(vif.src_drv_cb.busy !==0)
                        @(vif.src_drv_cb);
                vif.src_drv_cb.data_in <= req.parity;

                repeat(2)
                @(vif.src_drv_cb);

                `uvm_info("SRC_DRIVER", "Printing from driver",UVM_LOW)
                req.print();
endtask



