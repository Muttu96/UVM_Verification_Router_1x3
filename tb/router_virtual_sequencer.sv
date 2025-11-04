class router_virtual_sequencer extends uvm_sequencer#(uvm_sequence_item);
        `uvm_component_utils(router_virtual_sequencer)

        src_sequencer   src_v_seqr[];
        dst_sequencer   dst_v_seqr[];
        env_config      env_cfg;

        extern function new(string name = "router_virtual_sequencer", uvm_component parent = null);
        extern function void build_phase(uvm_phase phase);

endclass


function router_virtual_sequencer :: new(string name, uvm_component parent);
        super.new(name, parent);
endfunction:new

function void router_virtual_sequencer :: build_phase(uvm_phase phase);
        if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
                `uvm_fatal(get_type_name(),"Getting failed in router_virtual_sequencer")

        src_v_seqr = new[env_cfg.no_of_src_agt];
        foreach(src_v_seqr[i])
                src_v_seqr[i] = src_sequencer :: type_id :: create($sformatf("src_v_seqr[%0d]",i),this);

        dst_v_seqr = new[env_cfg.no_of_dst_agt];
        foreach(dst_v_seqr[i])
                dst_v_seqr[i] = dst_sequencer :: type_id :: create($sformatf("dst_v_seqr[%0d]",i),this);
endfunction

