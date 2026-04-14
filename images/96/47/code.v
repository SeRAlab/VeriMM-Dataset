module top_module(
    input [15:0] a,
    input [15:0] b,
    input [1:0] op, // Select between addition, subtraction, and bitwise AND
    output reg [31:0] result // Changed to reg since we're assigning in an always block
);wire [15:0] adder_out;
wire [15:0] sub_out;
wire [15:0] and_out;

assign adder_out = a + b;
assign sub_out = a - b;
assign and_out = a & b;

always @(*) begin
    case (op)
        2'b00: result = {16'b0, adder_out}; // Addition
        2'b01: result = {16'b0, sub_out};   // Subtraction
        2'b10: result = {16'b0, and_out};   // Bitwise AND
        default: result = 32'b0;            // Default to zero if invalid op
    endcase
end

endmodule