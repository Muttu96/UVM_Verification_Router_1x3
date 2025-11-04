interface router_if(input bit clock);

        //properties
        logic [7:0] data_in;
        logic [7:0] data_out;
        logic pkt_vld;
        logic error;
        logic busy;
        logic rstn;
        logic read_enb;
        logic vld_out;

//clocking block of source driver
clocking src_drv_cb@(posedge clock);
        output rstn;
        output pkt_vld;
        output data_in;
        input error;
        input busy;
endclocking


//clocking block of source monitor
clocking src_mon_cb@(posedge clock);
        input rstn;
        input pkt_vld;
        input data_in;
        input error;
        input busy;
endclocking


//clocking block of destination driver
clocking dst_drv_cb@(posedge clock);
        input vld_out;
        output read_enb;
endclocking


//clocking block of destination monitor
clocking dst_mon_cb@(posedge clock);
        input data_out;
        input vld_out;
        input read_enb;
endclocking

//modport of source driver
modport SRC_DRV_MP(clocking src_drv_cb);


//modport of source monitor
modport SRC_MON_MP(clocking src_mon_cb);


//modport of destination driver
modport DST_DRV_MP(clocking dst_drv_cb);


//modport of destination monitor
modport DST_MON_MP(clocking dst_mon_cb);

endinterface
