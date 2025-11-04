module router_top;

        import router_test_pkg::*;
        import uvm_pkg::*;
        `include "uvm_macros.svh"

        bit clock;
        always
                #5 clock=!clock;

        router_if       src_in0(clock);
        router_if       dst_in0(clock);
        router_if       dst_in1(clock);
        router_if       dst_in2(clock);

        router_1X3 DUV(.clk(clock), .rstn(src_in0.rstn), .pkt_valid(src_in0.pkt_vld), .data_in(src_in0.data_in), .error(src_in0.error), .busy(src_in0.busy),
                        .data_out0(dst_in0.data_out),  .data_out1(dst_in1.data_out), .data_out2(dst_in2.data_out),
                        .vld_out0(dst_in0.vld_out),    .vld_out1(dst_in1.vld_out),   .vld_out2(dst_in2.vld_out),
                        .read_en0(dst_in0.read_enb), .read_en1(dst_in1.read_enb), .read_en2(dst_in2.read_enb));

        initial
                begin

                        `ifdef VCS
                        $fsdbDumpvars(0,router_top);
                        `endif

                        uvm_config_db #(virtual router_if)::set(null,"*","src_in0",src_in0);
                        uvm_config_db #(virtual router_if)::set(null,"*","dst_in0",dst_in0);
                        uvm_config_db #(virtual router_if)::set(null,"*","dst_in1",dst_in1);
                        uvm_config_db #(virtual router_if)::set(null,"*","dst_in2",dst_in2);

                        run_test();
                end
endmodule

