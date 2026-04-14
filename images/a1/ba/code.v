module top_module(
    input clk,  // Added clock input
    input [3:0] a,
    input [3:0] b,
    output [3:0] out_sum,
    output [7:0] out_not,
    output reg out_greater_than_or_equal_to_8
);reg [3:0] shift_reg_a;
    reg [3:0] shift_reg_b;
    wire [3:0] xor_out;
    wire [3:0] and_out;
    wire [3:0] or_out;
    wire [3:0] sum_out;
    wire [7:0] not_out;

    // Shift registers
    always @(posedge clk) begin
        shift_reg_a <= {shift_reg_a[2:0], a};
        shift_reg_b <= {shift_reg_b[2:0], b};
    end

    // XOR gates
    assign xor_out = shift_reg_a ^ shift_reg_b;

    // Combinational logic circuits
    assign and_out = shift_reg_a & shift_reg_b;
    assign or_out = shift_reg_a | shift_reg_b;
    assign sum_out = {xor_out[2], xor_out[1] ^ and_out[3], xor_out[0] ^ and_out[2], xor_out[3] ^ or_out[3]};
    assign not_out = {~shift_reg_b, ~shift_reg_a};

    // Output logic
    assign out_sum = sum_out;
    assign out_not = not_out;
    always @(sum_out) begin
        if (sum_out >= 8) begin
            out_greater_than_or_equal_to_8 <= 1;
        end else begin
            out_greater_than_or_equal_to_8 <= 0;
        end
    end

endmodule