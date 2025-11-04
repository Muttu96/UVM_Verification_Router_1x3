class router_test extends uvm_test;

        `uvm_component_utils(router_test)

        router_env envh;

        env_config      env_cfgh;
        src_config      src_cfgh[];
        dst_config      dst_cfgh[];

        int no_of_src_agt = 1;
        int no_of_dst_agt = 3;

        extern function new(string name = "router_test", uvm_component parent = null);
        extern function void build_phase(uvm_phase phase);

endclass

function router_test :: new(string name, uvm_component parent);
        super.new(name, parent);
endfunction:new

function void router_test :: build_phase(uvm_phase phase);
        super.build_phase(phase);

        env_cfgh = env_config :: type_id :: create("env_cfgh",this);

        src_cfgh = new[no_of_src_agt];
        foreach(src_cfgh[i])
                begin
                        src_cfgh[i] = src_config :: type_id :: create($sformatf("src_cfgh[%0d]",i));

                        if(!uvm_config_db#(virtual router_if)::get(this,"",$sformatf("src_in%0d",i),src_cfgh[i].vif))
                                `uvm_fatal(get_type_name(),"getting failed in test")
                        src_cfgh[i].is_active = UVM_ACTIVE;
                end

        dst_cfgh = new[no_of_dst_agt];
        foreach(dst_cfgh[i])
                begin
                        dst_cfgh[i] = dst_config:: type_id :: create($sformatf("dst_cfgh[%0d]",i));

                        if(!uvm_config_db#(virtual router_if)::get(this,"",$sformatf("dst_in%0d",i),dst_cfgh[i].vif))
                                `uvm_fatal(get_type_name(),"getting failed in test")
                        dst_cfgh[i].is_active = UVM_ACTIVE;
                end

        env_cfgh.no_of_src_agt = no_of_src_agt;
        env_cfgh.no_of_dst_agt = no_of_dst_agt;

        env_cfgh.src_cfgh = src_cfgh;
        env_cfgh.dst_cfgh = dst_cfgh;

        uvm_config_db#(env_config) :: set(this,"*","env_config",env_cfgh);

        envh = router_env :: type_id :: create("envh",this);

endfunction:build_phase



//small test class
class small_test extends router_test;
        `uvm_component_utils(small_test)
        bit[1:0] addr;
//      small_pkt small_pkt_h;
//      router_seq router_seq_h;

        virtual_small_pkt v_s_pkt;

        extern function new(string name = "small_pkt", uvm_component parent = null);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass : small_test

function small_test :: new(string name, uvm_component parent);
        super.new(name, parent);
endfunction

function void small_test :: build_phase(uvm_phase phase);
        super.build_phase(phase);
//      small_pkt_h = small_pkt :: type_id :: create("small_pkt_h");
//      router_seq_h = router_seq :: type_id :: create("router_seq_h");

        v_s_pkt = virtual_small_pkt ::  type_id :: create("v_s_pkt");

endfunction:build_phase


task small_test :: run_phase(uvm_phase phase);
        addr = 2'b00;
        uvm_config_db #(bit[1:0]):: set(this, "*", "addr", addr);
        phase.raise_objection(this);
//              small_pkt_h.start(envh.src_agt_toph.src_agth[0].src_seqrh);
//              router_seq_h.start(envh.dst_agt_toph.dst_agth[addr].dst_seqrh);

                v_s_pkt.start(envh.v_seqrh);

        #200;
        phase.drop_objection(this);
endtask:run_phase



//medium test class
class medium_test extends router_test;
        `uvm_component_utils(medium_test)
        bit[1:0] addr;
//      medium_pkt medium_pkt_h;
        virtual_medium_pkt v_m_pkt;


        extern function new(string name = "medium_pkt", uvm_component parent = null);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass : medium_test

function medium_test :: new(string name, uvm_component parent);
        super.new(name, parent);
endfunction


function void medium_test :: build_phase(uvm_phase phase);
        super.build_phase(phase);
        //medium_pkt_h = medium_pkt :: type_id :: create("medium_pkt_h");
        v_m_pkt = virtual_medium_pkt ::  type_id :: create("v_m_pkt");

endfunction:build_phase


task medium_test :: run_phase(uvm_phase phase);
        addr = 2'b01;
        uvm_config_db #(bit[1:0]):: set(this, "*", "addr", addr);
        phase.raise_objection(this);
        //      medium_pkt_h.start(envh.src_agt_toph.src_agth[0].src_seqrh);
                v_m_pkt.start(envh.v_seqrh);
        phase.drop_objection(this);
endtask:run_phase


//large test class
class large_test extends router_test;
        `uvm_component_utils(large_test)
        bit[1:0] addr;
        //large_pkt large_pkt_h;
        virtual_large_pkt v_l_pkt;

        extern function new(string name = "large_pkt", uvm_component parent = null);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);

endclass : large_test

function large_test :: new(string name, uvm_component parent);
        super.new(name, parent);
endfunction


function void large_test :: build_phase(uvm_phase phase);
        super.build_phase(phase);
//      large_pkt_h = large_pkt :: type_id :: create("large_pkt_h");
        v_l_pkt = virtual_large_pkt ::  type_id :: create("v_l_pkt");

endfunction:build_phase

task large_test :: run_phase(uvm_phase phase);
        addr = 2'b10;
        uvm_config_db #(bit[1:0]):: set(this, "*", "addr", addr);
        phase.raise_objection(this);
        //      large_pkt_h.start(envh.src_agt_toph.src_agth[0].src_seqrh);
                v_l_pkt.start(envh.v_seqrh);
        #2000;
        phase.drop_objection(this);
endtask:run_phase

         
