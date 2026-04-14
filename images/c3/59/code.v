module twos_complement (
    input [3:0] in,
    output reg [3:0] out);
    
    assign out = ~in + 1;
    
endmodule

module top_module (
    input [3:0] in,
    output reg [3:0] out);
    
    twos_complement tc(in, out);
    
endmodule