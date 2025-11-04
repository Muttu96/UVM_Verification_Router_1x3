module router_fifo(clk, rstn, we, re, sft_rst, lfd_state, data_in, empty, full, data_out);
        input clk,rstn,we,re,sft_rst,lfd_state;
        input [7:0] data_in;
        output empty,full;
        output reg [7:0] data_out;

reg [8:0]mem[15:0];
integer i;
reg [5:0]temp;
reg [4:0] w_ptr, r_ptr;
reg lfd_s;

assign full = (w_ptr=={~r_ptr[4],r_ptr[3:0]})?1'b1:1'b0;
//assign full = (w_ptr == 5'd16 && r_ptr == 5'd0);
assign empty = (w_ptr == r_ptr);

always@(posedge clk)
begin
        if(!rstn)
        begin
                w_ptr <= 5'd0;
                for(i=0;i<16;i=i+1)
                        mem[i] <= 9'd0;
        end
        else if(sft_rst)
        begin
                w_ptr <= 5'd0;
                for(i=0;i<16;i=i+1)
                        mem[i] <= 9'd0;
        end
        else if(we  && !full)
        begin
                mem[w_ptr[3:0]] <= {lfd_s,data_in};
                w_ptr <= w_ptr+1'b1;
        end
        else
                w_ptr <= w_ptr;
end
always@(posedge clk)
        begin
        if(!rstn)
        begin
                r_ptr <= 5'd0;
                data_out <= 8'd0;
        end

        else if(sft_rst)
        begin
                data_out <= 8'dz;
                //r_ptr <= 5'd0;
        end

        else if (temp == 6'b0)
                data_out <= 8'bz;

        else if(re && !empty)
        begin
                        data_out <= mem[r_ptr[3:0]][7:0];
                        r_ptr <= r_ptr + 1'b1;
                        //mem[r_ptr] <= 0;
        end
end

always@(posedge clk)
begin
        if(rstn == 1'b0)
                lfd_s <= 1'b0;
        else if(sft_rst)
                lfd_s <= 1'b0;
        else
                lfd_s <= lfd_state;
end

always@(posedge clk)
begin
        if(rstn == 1'b0)
                temp <= 6'b0;
        else if(sft_rst == 1'b1)
                temp <= 6'b0;
        else if( !empty && re )
        begin
                if ( mem[r_ptr[4]][8] == 1)
                temp <= mem[r_ptr[4]][7:2]+1'b1;
        else if(temp != 6'd0)
                temp <= temp - 1'b1;
        end
end

endmodule
