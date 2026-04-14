module top_module( 
    input clk, // Added clk input
    input [2:0] a,
    input [2:0] b,
    output [2:0] out_xor_bitwise,
    output out_and_logical,
    output [5:0] out_not
);// Pipeline registers
    reg [2:0] a_reg1, a_reg2;
    reg [2:0] b_reg1, b_reg2;
    reg [2:0] not_a_reg1, not_a_reg2;
    reg [2:0] not_b_reg1, not_b_reg2;
    reg [2:0] xor_bitwise_reg1, xor_bitwise_reg2; // Changed to [2:0] for bitwise result
    reg and_logical_reg1, and_logical_reg2;

    // Combinational logic
    assign out_xor_bitwise = xor_bitwise_reg2;
    assign out_and_logical = and_logical_reg2;
    assign out_not = {not_a_reg2, not_b_reg2};

    // Pipeline stages
    always @(posedge clk) begin
        a_reg1 <= a;
        b_reg1 <= b;
        not_a_reg1 <= ~a;
        not_b_reg1 <= ~b;
        xor_bitwise_reg1 <= a_reg1 ^ b_reg1;
        and_logical_reg1 <= a_reg1 & b_reg1;
    end

    always @(posedge clk) begin
        a_reg2 <= a_reg1;
        b_reg2 <= b_reg1;
        not_a_reg2 <= not_a_reg1;
        not_b_reg2 <= not_b_reg1;
        xor_bitwise_reg2 <= xor_bitwise_reg1;
        and_logical_reg2 <= and_logical_reg1;
    end

endmodule