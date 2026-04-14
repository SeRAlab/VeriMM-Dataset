module top_module(
    A, B, op, clk,
    out, carry, zero
);// Inputs
    input [7:0] A, B;
    input [2:0] op;
    input clk;

    // Outputs
    output reg [7:0] out;
    output reg carry;
    output reg zero;

    // Local signals
    wire [8:0] sum;
    wire [8:0] diff;
    wire [7:0] and_out;
    wire [7:0] or_out;
    wire [7:0] xor_out;
    wire [7:0] shift_out;

    // Arithmetic logic
    assign sum = A + B;
    assign diff = A - B;
    assign and_out = A & B;
    assign or_out = A | B;
    assign xor_out = A ^ B;
    assign shift_out = (op[2] == 0) ? (A << B) : (A >> B);

    // Output selection
    always @(posedge clk) begin
        case (op)
            3'b000: out <= sum[7:0];
            3'b001: out <= diff[7:0];
            3'b010: out <= and_out;
            3'b011: out <= or_out;
            3'b100: out <= xor_out;
            3'b101: out <= shift_out[7:0];
            3'b110: out <= shift_out[7:0];
            default: out <= 8'b0;
        endcase
        carry <= sum[8];
        zero <= (out == 8'b0);
    end

endmodule