module top_module(
    input                   a_clk,
    input                   a_wen,
    input   [7:0]           a_addr,
    input   [7:0]           a_wdata,
    output reg [7:0]        a_rdata,

    input                   b_clk,
    input                   b_wen,
    input   [7:0]           b_addr,
    input   [7:0]           b_wdata,
    output reg [7:0]        b_rdata
    );reg     [7:0]           mem[0:255];
    

    always @( posedge a_clk )
        if ( a_wen )
            mem[a_addr] <= a_wdata;

    always @( posedge b_clk )
        if ( b_wen )
            mem[b_addr] <= b_wdata;

    always @( posedge a_clk )
        a_rdata <= mem[a_addr];

    always @( posedge b_clk )
        b_rdata <= mem[b_addr];

endmodule