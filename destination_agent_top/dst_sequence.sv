class router_seq extends uvm_sequence#(dst_xtn);
        `uvm_object_utils(router_seq)

        extern function new(string name = "router_seq");
        extern task body();

endclass

function router_seq :: new(string name);
        super.new(name);
endfunction:new

task router_seq :: body();
        req = dst_xtn :: type_id :: create("req");
        start_item(req);
        assert(req.randomize() with {no_of_cycles inside {[0:30]};});
        finish_item(req);
endtask
