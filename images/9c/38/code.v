module top_module(
    input reset,
    input clk_sys,
    input [1:0] addr,
    input we_n,
    input [7:0] idata,
    output [7:0] opa,
    output [7:0] opb,
    output [7:0] opc,
    output [7:0] odata
);// Dummy implementation for k580vv55
    assign opa = idata; // Example functionality
    assign opb = idata; // Example functionality
    assign opc = idata; // Example functionality
    assign odata = idata; // Example functionality
endmodule