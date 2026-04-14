module top_module(
    input [7:0] op1,
    input [7:0] op2,
    input [1:0] opcode,
    output reg [7:0] result  // Change output to reg type
);wire [7:0] add_out;
wire [7:0] sub_out;
wire [15:0] mul_out;
wire [7:0] div_out;
wire [7:0] zero;

assign zero = 8'b0;

// Adder
assign add_out = op1 + op2;

// Subtractor
assign sub_out = op1 - op2;

// Multiplier
assign mul_out = op1 * op2;

// Divider
assign div_out = (op2 != zero) ? (op1 / op2) : 8'b0;  // Handle division by zero

always @(*) begin
    case(opcode)
        2'b00: result = add_out;
        2'b01: result = sub_out;
        2'b10: result = mul_out[15:8];
        2'b11: result = div_out;
        default: result = 8'b0;
    endcase
end

endmodule