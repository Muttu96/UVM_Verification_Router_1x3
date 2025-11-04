class dst_sequencer extends uvm_sequencer#(dst_xtn);

        `uvm_component_utils(dst_sequencer)


        extern function new(string name = "dst_sequencer", uvm_component parent = null);
        extern function void build_phase(uvm_phase phase);

endclass


function dst_sequencer :: new(string name, uvm_component parent);
        super.new(name, parent);
endfunction:new


function void dst_sequencer :: build_phase(uvm_phase phase);
        super.build_phase(phase);

endfunction:build_phase
