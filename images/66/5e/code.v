module top_module(
    input wire sel,
    input wire [7:0] data0,
    input wire [7:0] data1,
    output wire [7:0] bus1
    );assign bus1 = sel?data1:data0;
endmodule