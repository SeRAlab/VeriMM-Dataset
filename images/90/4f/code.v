module top_module(
    input [3:0] in,
    output [15:0] out
);wire [3:0] abs_in = (in < 0) ? -in : in;
    wire [15:0] extended = { {12{in[3]}}, in };
    
    assign out = (in < 0) ? -extended : extended;
    
endmodule