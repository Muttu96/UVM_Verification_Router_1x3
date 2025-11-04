class dst_xtn extends uvm_sequence_item;

        `uvm_object_utils(dst_xtn)

        bit [7:0] header;
        bit [7:0] payload_data[];
        bit [7:0] parity;

        rand bit [5:0] no_of_cycles;

        extern function new(string name = "dst_xtn");


        virtual function void do_print(uvm_printer printer);
                printer.print_field("header", this.header, 8 , UVM_DEC);
                foreach(payload_data[i])
                        begin
                                printer.print_field($sformatf("payload_data[%0d]",i), this.payload_data[i], 8, UVM_DEC);
                        end
                printer.print_field("parity", this.parity, 8 , UVM_DEC);
                printer.print_field("no_of_cycles", this.no_of_cycles, 6, UVM_DEC);
        endfunction

endclass

function dst_xtn :: new(string name);
        super.new(name);
endfunction
