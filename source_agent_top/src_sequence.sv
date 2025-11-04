class base_seq extends uvm_sequence #(src_xtn);

        `uvm_object_utils(base_seq)

        extern function new(string name = "base_seq");

endclass : base_seq

function base_seq :: new(string name);
        super.new(name);
endfunction


//small pkt seq
class small_pkt extends base_seq;

        `uvm_object_utils(small_pkt)
        bit [1:0] addr;

        extern function new(string name = "small_pkt");
        extern task body();

endclass : small_pkt

function small_pkt :: new(string name);
        super.new(name);
endfunction

task small_pkt :: body();
        req = src_xtn :: type_id :: create("req");
        if(!uvm_config_db #(bit[1:0])::get(null, get_full_name(), "addr", addr))
                `uvm_fatal(get_type_name(),"Getting failed in task body")
        start_item(req);
        req.randomize() with {header[7:2]<14; header[1:0]==addr ;} ;
        finish_item(req);
endtask


//medium pkt seq
class medium_pkt extends base_seq;

        `uvm_object_utils(medium_pkt)
        bit [1:0] addr;

        extern function new(string name = "medium_pkt");
        extern task body();

endclass : medium_pkt

function medium_pkt :: new(string name="medium_pkt");
        super.new(name);
endfunction

task medium_pkt :: body();
        req = src_xtn :: type_id :: create("req");
        if(!uvm_config_db #(bit[1:0])::get(null, get_full_name(), "addr", addr))
                `uvm_fatal(get_type_name(),"Getting failed in task body")
//      $display("===================================================================%0d",addr);
        start_item(req);
        req.randomize() with {header[7:2] inside {[16:30]}; header[1:0]==addr ;};
        finish_item(req);
endtask


//large pkt seq
class large_pkt extends base_seq;

        `uvm_object_utils(large_pkt)
        bit [1:0] addr;

        extern function new(string name = "large_pkt");
        extern task body();

endclass : large_pkt

function large_pkt :: new(string name);
        super.new(name);
endfunction

task large_pkt :: body();
        req = src_xtn :: type_id :: create("req");
        if(!uvm_config_db #(bit[1:0])::get(null, get_full_name(),"addr",addr))
                `uvm_fatal(get_type_name(),"Getting failed in task body")
        start_item(req);
        req.randomize() with {header[7:2] inside {[31:64]}; header[1:0]==addr ;};
        finish_item(req);
endtask


//error pkt seq
class error_pkt extends base_seq;
        `uvm_object_utils(error_pkt)
        bit [1:0] addr;
        extern function new(string name = "error_pkt");
        extern task body();
endclass : error_pkt

function error_pkt :: new(string name);
        super.new(name);
endfunction

task error_pkt :: body();
        req = src_xtn :: type_id :: create("req");
        if(!uvm_config_db #(bit[1:0])::get(null, get_full_name(),"addr",addr))
                `uvm_fatal(get_type_name(),"Getting failed in task body")
        start_item(req);
        req.randomize() with {header[7:2] inside {[65:99]}; header[1:0]==addr ;};
        finish_item(req);
endtask



