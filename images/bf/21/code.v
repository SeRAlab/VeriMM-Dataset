module top_module(
    input wire clk,
    input wire rst,
    input wire [3:0] operand1,
    input wire [3:0] operand2,
    input wire [1:0] operation,
    output wire [3:0] result
);reg [3:0] temp_result;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        temp_result <= 0;
    end else begin
        case (operation)
            2'b00: temp_result <= operand1 + operand2; // addition
            2'b01: temp_result <= operand1 - operand2; // subtraction
            2'b10: temp_result <= operand1 * operand2; // multiplication
            2'b11: temp_result <= operand1 / operand2; // division
        endcase
    end
end

assign result = temp_result;

endmodule