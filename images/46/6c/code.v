module top_module(
    input [3:0] in_1,
    input [3:0] in_2,
    input [3:0] in_3,
    input [3:0] in_4,
    output out_and,
    output out_or,
    output out_xor
);wire [3:0] and_1;
    wire [3:0] and_2;
    wire [3:0] or_1;
    wire [3:0] or_2;
    wire [3:0] xor_1;
    wire [3:0] xor_2;
    wire [3:0] xor_3;
    
    assign and_1 = in_1 & in_2;
    assign and_2 = in_3 & in_4;
    assign or_1 = in_1 | in_2;
    assign or_2 = in_3 | in_4;
    assign xor_1 = in_1 ^ in_2;
    assign xor_2 = in_3 ^ in_4;
    assign xor_3 = xor_1 ^ xor_2;
    
    assign out_and = and_1 & and_2;
    assign out_or = or_1 | or_2;
    assign out_xor = xor_3;
    
endmodule