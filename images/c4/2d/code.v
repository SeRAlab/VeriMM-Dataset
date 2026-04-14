module calculator(input [7:0] num1, num2, input [2:0] opcode, input clk, output reg [7:0] result);

always @(posedge clk) begin
    case(opcode)
        3'b000: result <= num1 + num2;
        3'b001: result <= num1 - num2;
        3'b010: result <= num1 * num2;
        3'b011: result <= num1 / num2;
    endcase
end

endmodule