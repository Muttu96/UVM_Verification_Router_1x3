
module router_register(
        input clk, rstn,
        input pkt_vld, fifo_full, rst_int_reg, det_addr, ld_state, laf_state, full_state, lfd_state,
        input [7:0] data_in,
        output reg parity_done, low_pkt_vld,
        output reg error,
        output reg [7:0] data_out);

reg  [7:0] header_reg;
reg  [7:0] fifo_full_reg;
reg  [7:0] pkt_parity_reg;
reg  [7:0] internal_parity_reg;

//Header_reg logic
always@(posedge clk)
begin
        if(!rstn)
                header_reg <= 0;
        else if(det_addr && pkt_vld && data_in[1:0] != 3)
                header_reg <= data_in;
        else
                header_reg <= header_reg;
end

//fifo_full_reg logic
/*always@(posedge clk)
begin
        if(!rstn)
                fifo_full_reg <= 0;
        else if (fifo_full && ld_state)
                fifo_full_reg <= data_in;
        else
                fifo_full_reg <= fifo_full_reg;
end*/
//internal_parity_reg logic
always@(posedge clk)
begin
        if(!rstn)
                internal_parity_reg <= 1'b0;
        else if(det_addr)
                internal_parity_reg <= 1'b0;
   else if(lfd_state)
                internal_parity_reg <= (internal_parity_reg ^ header_reg);
        else if(pkt_vld && ld_state && !full_state)
                internal_parity_reg <= (internal_parity_reg ^ data_in);
        else
                internal_parity_reg <= internal_parity_reg;
end

//packet_parity_reg logic
always@(posedge clk)
begin
        if(!rstn)
                pkt_parity_reg <= 0;
        else if(det_addr)
                pkt_parity_reg <= 0;
        else if(ld_state && !pkt_vld)
                pkt_parity_reg <= data_in;
        else
                pkt_parity_reg <= pkt_parity_reg;
end


//data_out logic
always@(posedge clk)
begin
        if(!rstn)
        begin
                data_out <= 0;
                fifo_full_reg <= 0;
        end
        else if(det_addr && pkt_vld && data_in[1:0] != 2'd3)
               data_out <= data_out;
        else if(lfd_state)
           data_out <= header_reg;
        else if(ld_state && !fifo_full)
               data_out <= data_in;
        else if(ld_state && fifo_full)
               fifo_full_reg <= data_in;
        else if(laf_state)
         data_out <= fifo_full_reg;
        else
                 data_out <= data_out;

end


//parity_done logic
always@(posedge clk)
begin
        if(!rstn)
                parity_done <= 0;
        else if(det_addr)
                parity_done <= 0;
        else if( (ld_state && !fifo_full && !pkt_vld)  || (laf_state && low_pkt_vld && !parity_done) )
                parity_done <= 1;
        else
                parity_done <= parity_done;
end


//low_paket_valid logic
always@(posedge clk)
begin
        if(!rstn)
                low_pkt_vld <= 1'b0;
        else if(rst_int_reg)
                low_pkt_vld <= 0;
        else if(ld_state && !pkt_vld)
                low_pkt_vld <= 1'b1;
        else
                low_pkt_vld <= low_pkt_vld;
end


//error logic
always@(posedge clk)
begin
        if(!rstn)
                error <= 1'b0;
        else if(parity_done)
                begin
                        if(internal_parity_reg != pkt_parity_reg)
                        error <= 1'b1;
                else
                        error <= 1'b0;
                end
end

endmodule
