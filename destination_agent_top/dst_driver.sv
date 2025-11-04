class dst_driver extends uvm_driver#(dst_xtn);

        `uvm_component_utils(dst_driver)
        virtual router_if.DST_DRV_MP vif;
        dst_config dst_cfg;

        extern function new(string name = "dst_driver", uvm_component parent = null);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task send_to_dut(dst_xtn req);

endclass

function dst_driver :: new(string name, uvm_component parent);
        super.new(name, parent);
endfunction:new

function void dst_driver :: build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(dst_config)::get(this, "", "dst_config", dst_cfg))
                `uvm_fatal(get_type_name(),"getting failed in dst driver")
endfunction:build_phase

function void dst_driver :: connect_phase (uvm_phase phase);
        vif = dst_cfg.vif;
endfunction

task dst_driver :: run_phase(uvm_phase phase);
        forever
                begin
                        seq_item_port.get_next_item(req);
                        send_to_dut(req);
                        seq_item_port.item_done();
                end
endtask

task dst_driver :: send_to_dut(dst_xtn req);
        @(vif.dst_drv_cb);
        while(vif.dst_drv_cb.vld_out !== 1)
                @(vif.dst_drv_cb);

        $display("vld_out is%d",vif.dst_drv_cb.vld_out);

        @(vif.dst_drv_cb);
        vif.dst_drv_cb.read_enb <= 1;
        @(vif.dst_drv_cb);

        while(vif.dst_drv_cb.vld_out !== 0)
                @(vif.dst_drv_cb);

        $display("vld_out is%d",vif.dst_drv_cb.vld_out);

        @(vif.dst_drv_cb);
        vif.dst_drv_cb.read_enb <= 0;

        `uvm_info("DST_DRIVER", $sformatf("Printing from driver\n%s",req.sprint()),UVM_LOW)

endtask

