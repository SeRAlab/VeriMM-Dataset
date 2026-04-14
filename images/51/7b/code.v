module top_module(
    input                   sys_clk     ,
    input                   sys_rst_n   ,
    input           [7:0]   da_data     ,
    output                  da_clk_10b2 ,
    output          [9:0]   da_out_10b2
    );assign                  da_clk_10b2 = ~sys_clk;
    assign                  da_out_10b2[9:2] = da_data;
    assign                  da_out_10b2[1:0] = 2'b00;
endmodule