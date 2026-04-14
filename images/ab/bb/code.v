module top_module(
    input [3:0] A,
    input [3:0] B,
    input C,
    input [3:0] ALU_in,
    input [2:0] OP,
    output reg [3:0] out
);reg [3:0] add_sub_out;
reg [3:0] alu_out;

// Adder/Subtractor module
always @(*) begin
    if (C == 0) begin
        add_sub_out = A + B;
    end else begin
        add_sub_out = A - B;
    end
end

// ALU module
always @(*) begin
    case (OP)
        3'b000: alu_out = ALU_in + add_sub_out; // Addition
        3'b001: alu_out = ALU_in - add_sub_out; // Subtraction
        3'b010: alu_out = ALU_in & add_sub_out; // Bitwise AND
        3'b011: alu_out = ALU_in | add_sub_out; // Bitwise OR
        3'b100: alu_out = ALU_in ^ add_sub_out; // Bitwise XOR
        3'b101: alu_out = ALU_in << add_sub_out; // Shift left
        3'b110: alu_out = ALU_in >> add_sub_out; // Shift right
        3'b111: alu_out = {ALU_in[2:0], ALU_in[3]}; // Rotate left
    endcase
end

// Additive functional module
always @(*) begin
    out = add_sub_out + alu_out;
end

endmodule