class scoreboard extends uvm_scoreboard;

        `uvm_component_utils(scoreboard)

        uvm_tlm_analysis_fifo#(src_xtn)src_fifoh[];
        uvm_tlm_analysis_fifo#(dst_xtn)dst_fifoh[];
        env_config      env_cfg;
        src_xtn         src_xtnh;
        dst_xtn         dst_xtnh;

        extern function new(string name = "scoreboard", uvm_component parent = null);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task compare(src_xtn src_xtnh, dst_xtn dst_xtnh);


        covergroup src_cg;
                ADDR : coverpoint src_xtnh.header[1:0]
                        {bins addr0={0};
                        bins addr1={1};
                        bins addr2={2};}

                PAYLOAD_DATA : coverpoint src_xtnh.header[7:2]
                                {bins small_pkt={[1:15]};
                                bins medium_pkt={[16:30]};
                                bins large_pkt={[31:63]};}

                ERROR : coverpoint src_xtnh.error
                        {bins no_error={0};}
                //      bins error={1};}
        endgroup

        covergroup dst_cg;
                ADDR : coverpoint dst_xtnh.header[1:0]
                        {bins addr0={0};
                        bins addr1={1};
                        bins addr2={2};}

                PAYLOAD_DATA : coverpoint dst_xtnh.header[7:2]
                                {bins small_pkt={[1:15]};
                                bins medium_pkt={[16:30]};
                                bins large_pkt={[31:63]};}
        endgroup

endclass

function scoreboard :: new(string name, uvm_component parent);
        super.new(name, parent);
        src_cg=new();
        dst_cg=new();
endfunction:new

function void scoreboard :: build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(env_config)::get(this,"","env_config",env_cfg))
                `uvm_fatal(get_type_name(),"Getting failed in scoreboard")
        src_fifoh = new[env_cfg.no_of_src_agt];
        foreach(src_fifoh[i])
                src_fifoh[i] = new($sformatf("src_fifoh[%0d]",i),this);

        dst_fifoh = new[env_cfg.no_of_dst_agt];
        foreach(dst_fifoh[i])
                dst_fifoh[i] = new($sformatf("dst_fifoh[%0d]",i),this);
endfunction:build_phase

task scoreboard :: run_phase(uvm_phase phase);
        forever
                begin
                        fork
                                begin : A
                                        src_fifoh[0].get(src_xtnh);
                                        src_xtnh.print();
                                end
                                begin : B
                                        fork
                                                begin
                                                        dst_fifoh[0].get(dst_xtnh);
                                                        dst_xtnh.print();
                                                        compare(src_xtnh, dst_xtnh);
                                                end
                                                begin
                                                        dst_fifoh[1].get(dst_xtnh);
                                                        dst_xtnh.print();
                                                        compare(src_xtnh, dst_xtnh);
                                                end
                                                begin
                                                        dst_fifoh[2].get(dst_xtnh);
                                                        dst_xtnh.print();
                                                        compare(src_xtnh, dst_xtnh);
                                                end
                                        join_any
                                        disable fork;
                                end
                        join
                end
endtask

task scoreboard :: compare(src_xtn src_xtnh, dst_xtn dst_xtnh);
        if(src_xtnh.header == dst_xtnh.header)
                `uvm_info("HEADER","comparision success", UVM_LOW)
        else
                `uvm_info("HEADER","comparision failed", UVM_LOW)

        if(src_xtnh.payload_data == dst_xtnh.payload_data)
                `uvm_info("PAYLOAD_DATA","comparision success", UVM_LOW)
        else
                `uvm_info("PAYLOAD_DATA","comparision failed", UVM_LOW)

        if(src_xtnh.parity == dst_xtnh.parity)
                `uvm_info("PARITY","comparision success", UVM_LOW)
        else
                `uvm_info("PARITY","comparision failed", UVM_LOW)

        src_cg.sample();
        dst_cg.sample();
endtask


