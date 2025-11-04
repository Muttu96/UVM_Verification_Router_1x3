class src_agt_top extends uvm_env;

        `uvm_component_utils(src_agt_top)

        src_agent       src_agth[];
        env_config      env_cfgh;

        extern function new(string name = "src_agt_top", uvm_component parent = null);
        extern function void build_phase(uvm_phase phase);

endclass

function src_agt_top :: new(string name, uvm_component parent);
        super.new(name, parent);
endfunction:new

function void src_agt_top :: build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfgh))
                `uvm_fatal(get_type_name(), "getting failed in src_agt_top")

        src_agth = new[env_cfgh.no_of_src_agt];
        foreach(src_agth[i])
                begin
                        src_agth[i] = src_agent :: type_id :: create($sformatf("src_agth[%0d]",i),this);
                        uvm_config_db#(src_config)::set(this,$sformatf("src_agth[%0d]*",i),"src_config",env_cfgh.src_cfgh[i]);
                end
//      uvm_top.print_topology;

endfunction:build_phase

