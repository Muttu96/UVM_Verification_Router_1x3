class src_xtn extends uvm_sequence_item;

        `uvm_object_utils(src_xtn)

        rand bit [7:0] header;
        rand bit [7:0] payload_data[];
             bit [7:0] parity;
             bit       error;

        constraint c1 { header[1:0] != 3 ;}
        constraint c2 { header[7:2] != 0 ;}
        constraint c3 { payload_data.size == header[7:2] ;}


        function void post_randomize();
                parity = 0 ^ header;
                foreach(payload_data[i])
                        parity = parity ^ payload_data[i];
        endfunction:post_randomize

        virtual function void do_print(uvm_printer printer);
                printer.print_field("header", this.header, 8 , UVM_DEC);
                foreach(payload_data[i])
                        begin
                                printer.print_field($sformatf("payload_data[%0d]",i), this.payload_data[i], 8, UVM_DEC);
                        end
                printer.print_field("parity", this.parity, 8 , UVM_DEC);
                printer.print_field("error", this.error, 1, UVM_DEC);
        endfunction

endclass:src_xtn
