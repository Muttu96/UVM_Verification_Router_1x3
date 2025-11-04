class router_env extends uvm_env;

        `uvm_component_utils(router_env)

        src_agt_top     src_agt_toph;
        dst_agt_top     dst_agt_toph;
        scoreboard      sbh;
        env_config      env_cfg;
        router_virtual_sequencer        v_seqrh;

        extern function new(string name = "router_env", uvm_component parent = null);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);

endclass

function router_env :: new(string name, uvm_component parent);
        super.new(name, parent);
endfunction:new

function void router_env :: build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
                `uvm_fatal(get_type_name(),"Getting failed in router_virtual_sequencer")

        src_agt_toph = src_agt_top :: type_id :: create("src_agt_toph", this);
        dst_agt_toph = dst_agt_top :: type_id :: create("dst_agt_toph", this);
        sbh          = scoreboard  :: type_id :: create("sbh",          this);

        v_seqrh      = router_virtual_sequencer  :: type_id :: create("v_seqrh",this);

endfunction : build_phase


function void router_env :: connect_phase(uvm_phase phase);
        for(int i = 0; i<env_cfg.no_of_src_agt; i++)
                v_seqrh.src_v_seqr[i] = src_agt_toph.src_agth[i].src_seqrh;

        for(int i = 0; i<env_cfg.no_of_dst_agt; i++)
                v_seqrh.dst_v_seqr[i] = dst_agt_toph.dst_agth[i].dst_seqrh;

        for(int i=0 ; i<env_cfg.no_of_src_agt; i++)
        src_agt_toph.src_agth[i].src_monh.ap.connect(sbh.src_fifoh[i].analysis_export);

        for(int i=0 ; i<env_cfg.no_of_dst_agt; i++)
        dst_agt_toph.dst_agth[i].dst_monh.ap.connect(sbh.dst_fifoh[i].analysis_export);

endfunction

