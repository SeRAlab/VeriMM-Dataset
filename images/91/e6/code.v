module top_module(
    input wire [3:0] vec1,
    input wire [3:0] vec2,
    output wire [3:0] out_xor,
    output wire o4,
    output wire o3,
    output wire o2,
    output wire o1,
    output wire o0
);assign out_xor = vec1 ^ vec2;
    assign o4 = vec1 & vec2;
    
    assign o3 = out_xor[3];
    assign o2 = out_xor[2];
    assign o1 = out_xor[1];
    assign o0 = out_xor[0];

endmodule