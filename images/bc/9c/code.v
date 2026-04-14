module top_module(
    input [3:0] A,
    input [3:0] B,
    input [2:0] opcode,
    input carry_in,
    input invert,
    input clk,             // Added clock input
    output reg [3:0] result
);reg [3:0] temp_result;
    reg carry_out;

    always @(*) begin
        case (opcode)
            3'b000: temp_result = A + B + carry_in;
            3'b001: temp_result = A - B - carry_in;
            3'b010: temp_result = A & B;
            3'b011: temp_result = A | B;
            3'b100: temp_result = A ^ B;
            default: temp_result = 4'b0000;
        endcase

        if (invert) begin
            temp_result = ~B;
        end

        if (opcode == 3'b000) begin
            carry_out = (A[3] & B[3]) | (A[3] & carry_in) | (B[3] & carry_in);
        end else if (opcode == 3'b001) begin
            carry_out = (A[3] & ~B[3] & ~carry_in) | (~A[3] & B[3] & carry_in);
        end else begin
            carry_out = 1'b0;
        end
    end

    always @(posedge clk) begin
        result <= temp_result;
    end

endmodule