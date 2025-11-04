class env_config extends uvm_object;

        `uvm_object_utils(env_config)

        int no_of_src_agt;
        int no_of_dst_agt;

        src_config src_cfgh[];
        dst_config dst_cfgh[];

        extern function new(string name = "env_config");

endclass

function env_config :: new(string name);
        super.new(name);
endfunction:new

