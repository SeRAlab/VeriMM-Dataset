module top_module(
    clk,
    reset,
    address,
    out,
    load
 );input clk;             
    input reset;
    output load;             
    output [15:0] address;
    output [15:0] out;            
    
    assign load = 0;
    assign address = 0;
    assign out = 0;
    
endmodule