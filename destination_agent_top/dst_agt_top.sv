class dst_agt_top extends uvm_env;

        `uvm_component_utils(dst_agt_top)

        dst_agent       dst_agth[];
        env_config      env_cfgh;

        extern function new(string name = "dst_agt_top", uvm_component parent = null);
        extern function void build_phase(uvm_phase phase);

endclass

function dst_agt_top :: new(string name, uvm_component parent);
        super.new(name, parent);
endfunction:new

function void dst_agt_top :: build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfgh))
                `uvm_fatal(get_type_name(),"getting failed in dst agent")

        dst_agth = new[env_cfgh.no_of_dst_agt];
        foreach(dst_agth[i])
                begin
                        dst_agth[i] = dst_agent :: type_id :: create($sformatf("dst_agth[%0d]",i),this);

                        uvm_config_db#(dst_config)::set(this,$sformatf("dst_agth[%0d]*",i),"dst_config",env_cfgh.dst_cfgh[i]);
                end

endfunction:build_phase

