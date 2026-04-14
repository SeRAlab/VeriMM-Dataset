module top_module(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor,
    output reg [1:0] pos,
    output [7:0] final_output
);wire [3:0] in_not = ~in;
    wire [3:0] in_and = &in;
    wire [3:0] in_or = |in;
    wire [3:0] in_xor = ^in;
    
    assign out_and = in_and;
    assign out_or = in_or;
    assign out_xor = in_xor;
    
    wire [3:0] and_not = ~in_and;
    wire [3:0] or_not = ~in_or;
    wire [3:0] xor_not = ~in_xor;
    
    wire [2:0] and_not_pos = and_not[2:0] == 0 ? 3 : and_not[1:0] == 0 ? 2 : and_not[0] == 0 ? 1 : 0;
    wire [2:0] or_not_pos = or_not[2:0] == 0 ? 3 : or_not[1:0] == 0 ? 2 : or_not[0] == 0 ? 1 : 0;
    wire [2:0] xor_not_pos = xor_not[2:0] == 0 ? 3 : xor_not[1:0] == 0 ? 2 : xor_not[0] == 0 ? 1 : 0;
    
    wire [7:0] and_not_product = and_not_pos == 0 ? 0 : and_not_pos == 1 ? in[0] : and_not_pos == 2 ? in[1:0] : in[2:0];
    wire [7:0] or_not_product = or_not_pos == 0 ? 0 : or_not_pos == 1 ? in[0] : or_not_pos == 2 ? in[1:0] : in[2:0];
    wire [7:0] xor_not_product = xor_not_pos == 0 ? 0 : xor_not_pos == 1 ? in[0] : xor_not_pos == 2 ? in[1:0] : in[2:0];
    
    assign final_output = {and_not_product, or_not_product, xor_not_product};
    
    always @(*) begin
        if (in[0] == 1) pos = 0;
        else if (in[1] == 1) pos = 1;
        else if (in[2] == 1) pos = 2;
        else if (in[3] == 1) pos = 3;
        else pos = 0;
    end
    
endmodule