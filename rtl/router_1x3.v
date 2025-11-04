`timescale 1ps/1fs

module router_1X3 (
        input clk, rstn,
        input read_en0, read_en1, read_en2,
   input [7:0] data_in,
        input pkt_valid,
        output [7:0] data_out0, data_out1, data_out2,
        output vld_out0, vld_out1, vld_out2,
        output error, busy);


//FIFO BLOCK INSTANTIATION

wire [2:0] write_enb;
wire [7:0]din;

router_fifo FIFO_0 (.clk(clk), .rstn(rstn), .we(write_enb[0]), .sft_rst(sft_rst_0), .re(read_en0), .data_in(din),
                                                 .lfd_state(lfd), .data_out(data_out0), .empty(empty_0), .full(full_0));
router_fifo FIFO_1 (.clk(clk), .rstn(rstn), .we(write_enb[1]), .sft_rst(sft_rst_1), .re(read_en1), .data_in(din),
                                                 .lfd_state(lfd), .data_out(data_out1), .empty(empty_1), .full(full_1));
router_fifo FIFO_2 (.clk(clk), .rstn(rstn), .we(write_enb[2]), .sft_rst(sft_rst_2), .re(read_en2), .data_in(din),
                                                 .lfd_state(lfd), .data_out(data_out2), .empty(empty_2), .full(full_2));

//SYNCHRONIZER BLOCK INSTANTIATION

router_synchronizer SYNCHRONIZER (.clk(clk), .rstn(rstn),  .detect_addr(detect_addr), .data_in(data_in[1:0]), .write_en_reg(write_en_reg),
                                                                                         .vld0(vld_out0), .vld1(vld_out1), .vld2(vld_out2), .re0(read_en0),  .re1(read_en1),  .re2(read_en2),
                                                                                         .write_en(write_enb), .fifo_full(fifo_full), .empty0(empty_0), .empty1(empty_1), .empty2(empty_2),
                                                                .sft_rst0(sft_rst_0), .sft_rst1(sft_rst_1), .sft_rst2(sft_rst_2), .full0(full_0), .full1(full_1), .full2(full_2));


//FSM BLOCK INSTANTIATION

router_fsm FSM (.clk(clk), .rstn(rstn),  .pkt_vld(pkt_valid), .busy(busy), .parity_done(parity_done), .data_in(data_in[1:0]),
                                         .sft_rst0(sft_rst_0), .sft_rst1(sft_rst_1), .sft_rst2(sft_rst_2), .fifo_full(fifo_full), .low_pkt_vld(low_pkt_vld),
                                         .fifo_empty0(empty_0), .fifo_empty1(empty_1), .fifo_empty2(empty_2), .detect_addr(detect_addr), .ld_state(ld_state),
                                         .laf_state(laf_state), .full_state(full_state), .write_en_reg(write_en_reg), .rst_int_reg(rst_int_reg), .lfd_state(lfd));


//REGISTER BLOCK INSTANTIATION

router_register REGISTER (.clk(clk), .rstn(rstn), .pkt_vld(pkt_valid), .data_in(data_in), .fifo_full(fifo_full), .rst_int_reg(rst_int_reg),
                                                                  .det_addr(detect_addr), .ld_state(ld_state), .laf_state(laf_state), .full_state(full_state), .lfd_state(lfd),
                                                                  .parity_done(parity_done), .low_pkt_vld(low_pkt_vld), .error(error), .data_out(din));

endmodule
