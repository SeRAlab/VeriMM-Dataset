module top_module(
    input                   i_clk,

    output                  o_wen,
    output  [7:0]           o_addr,
    output  [7:0]           o_wdata,
    input   [7:0]           i_rdata
    );reg     [7:0]           cnt = 0;

    
    always @( posedge i_clk )
        if ( cnt < 8'd50 )
            cnt     <= cnt + 8'd1;

    
    assign o_wen    = ( cnt > 8'd10 ) && ( cnt < 8'd30 ) && ( cnt[0] == 1'b0 );
    assign o_addr   = cnt;
    assign o_wdata  = cnt;

endmodule