class router_virtual_sequence extends uvm_sequence#(uvm_sequence_item);
        `uvm_object_utils(router_virtual_sequence)

        router_virtual_sequencer v_seqrh;

        src_sequencer src_seqr[];
        dst_sequencer dst_seqr[];

        small_pkt       s_pkt;
        medium_pkt      m_pkt;
        large_pkt       l_pkt;
        error_pkt       e_pkt;

        router_seq      r_seqh;

        env_config      env_cfg;

        extern function new(string name = "router_virtual_sequence");
        extern task body();

endclass : router_virtual_sequence

function router_virtual_sequence :: new(string name);
        super.new(name);
endfunction

task router_virtual_sequence :: body();
        if(!uvm_config_db#(env_config)::get(null,get_full_name(),"env_config", env_cfg))
                `uvm_fatal(get_type_name(),"Getting failed in router_virtual_sequence")
        if(!$cast(v_seqrh, m_sequencer))
                `uvm_error("v_seqrh","Error at casting")

        src_seqr = new[env_cfg.no_of_src_agt];
        foreach(src_seqr[i])
                src_seqr[i] = v_seqrh.src_v_seqr[i];

        dst_seqr = new[env_cfg.no_of_dst_agt];
        foreach(dst_seqr[i])
                dst_seqr[i] = v_seqrh.dst_v_seqr[i];
endtask

class virtual_small_pkt extends router_virtual_sequence;
        `uvm_object_utils(virtual_small_pkt)

        small_pkt       s_pkt;
        router_seq      r_seqh;

        bit[1:0] addr;
        extern function new(string name = "virtual_small_pkt");
        extern task body();

endclass : virtual_small_pkt

function virtual_small_pkt :: new(string name);
        super.new(name);
        s_pkt = small_pkt :: type_id :: create("s_pkt");
        r_seqh = router_seq :: type_id :: create("r_seqh");
endfunction

task virtual_small_pkt :: body();

        if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"addr",addr))
                `uvm_fatal(get_type_name(),"Getting failed in virtual_small_pkt")
        super.body();
        fork
                foreach(src_seqr[i])
                        s_pkt.start(src_seqr[i]);
                r_seqh.start(dst_seqr[addr]);
        join
endtask


class virtual_medium_pkt extends router_virtual_sequence;
        `uvm_object_utils(virtual_medium_pkt)

        medium_pkt      m_pkt;
        router_seq      r_seqh;

        bit[1:0] addr;
        extern function new(string name = "virtual_medium_pkt");
        extern task body();

endclass : virtual_medium_pkt


function virtual_medium_pkt :: new(string name);
        super.new(name);
        m_pkt = medium_pkt :: type_id :: create("m_pkt");
        r_seqh = router_seq :: type_id :: create("r_seqh");
endfunction

task virtual_medium_pkt :: body();

        if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"addr",addr))
                `uvm_fatal(get_type_name(),"Getting failed in virtual_medium_pkt")

        super.body();

        fork
                foreach(src_seqr[i])
                        m_pkt.start(src_seqr[i]);
                r_seqh.start(dst_seqr[addr]);
        join
endtask



class virtual_large_pkt extends router_virtual_sequence;
        `uvm_object_utils(virtual_large_pkt)

        large_pkt       l_pkt;
        router_seq      r_seqh;

        bit[1:0] addr;
        extern function new(string name = "virtual_large_pkt");
        extern task body();

endclass : virtual_large_pkt

function virtual_large_pkt :: new(string name);
        super.new(name);
        l_pkt = large_pkt :: type_id :: create("l_pkt");
        r_seqh = router_seq :: type_id :: create("r_seqh");

endfunction

task virtual_large_pkt :: body();

        if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"addr",addr))
                `uvm_fatal(get_type_name(),"Getting failed in virtual_large_pkt")

        super.body();

        fork
                foreach(src_seqr[i])
                        l_pkt.start(src_seqr[i]);
                r_seqh.start(dst_seqr[addr]);
        join
endtask

