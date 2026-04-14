module top_module(
    input clk,
    input [7:0] d,
    input a,
    input b,
    output [7:0] q
);// XOR gate
    wire xor_out;
    assign xor_out = a ^ b;

    // 8-bit shift register
    reg [7:0] shift_reg;
    always @(posedge clk) begin
        shift_reg <= {shift_reg[6:0], d};
    end

    // Additive functional module
    assign q = shift_reg + xor_out;

endmodule