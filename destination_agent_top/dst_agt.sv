class dst_agent extends uvm_agent;

        `uvm_component_utils(dst_agent)

        dst_driver      dst_drvh;
        dst_monitor     dst_monh;
        dst_sequencer   dst_seqrh;

        dst_config dst_cfgh;

        extern function new(string name = "dst_agent", uvm_component parent = null);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);

endclass


function dst_agent :: new(string name, uvm_component parent);
        super.new(name, parent);
endfunction:new


function void dst_agent :: build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(dst_config)::get(this,"","dst_config",dst_cfgh))
                `uvm_fatal(get_type_name(), "getting failed in dst agent")

        dst_monh = dst_monitor :: type_id :: create("dst_monh", this);

        if(dst_cfgh.is_active == UVM_ACTIVE)
                begin
                        dst_drvh = dst_driver :: type_id :: create("dst_drvh", this);
                        dst_seqrh = dst_sequencer :: type_id :: create("dst_seqrh", this);
                end

endfunction:build_phase


function void dst_agent :: connect_phase(uvm_phase phase);
        if(dst_cfgh.is_active == UVM_ACTIVE)
                dst_drvh.seq_item_port.connect(dst_seqrh.seq_item_export);
endfunction:connect_phase
