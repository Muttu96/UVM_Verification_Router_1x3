class src_agent extends uvm_agent;

        `uvm_component_utils(src_agent)

        src_driver      src_drvh;
        src_monitor     src_monh;
        src_sequencer   src_seqrh;

        src_config      src_cfgh;

        extern function new(string name = "src_agent", uvm_component parent = null);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);

endclass


function src_agent :: new(string name, uvm_component parent);
        super.new(name, parent);
endfunction:new


function void src_agent :: build_phase(uvm_phase phase);

        super.build_phase(phase);

        if(!uvm_config_db#(src_config)::get(this,"","src_config",src_cfgh))
                `uvm_fatal(get_type_name(),"getting failed in src_agent")

        src_monh = src_monitor :: type_id :: create("src_monh", this);

        if(src_cfgh.is_active == UVM_ACTIVE)
                begin
                        src_drvh = src_driver :: type_id :: create("src_drvh", this);
                        src_seqrh = src_sequencer :: type_id :: create("src_seqrh", this);
                end
//      uvm_top.print_topology;

endfunction:build_phase


function void src_agent :: connect_phase(uvm_phase phase);
        if(src_cfgh.is_active == UVM_ACTIVE)
                src_drvh.seq_item_port.connect(src_seqrh.seq_item_export);
endfunction:connect_phase
