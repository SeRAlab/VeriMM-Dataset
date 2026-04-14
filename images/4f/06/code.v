module top_module(
    input clk,
    input rst,
    input clear,
    input [1:0] op,
    input [7:0] num1,
    input [7:0] num2,
    output reg [7:0] result
);reg [7:0] temp_result;

always @ (posedge clk) begin
    if (rst) begin
        temp_result <= 0;
    end else if (clear) begin
        temp_result <= 0;
    end else begin
        case (op)
            2'b00: temp_result <= num1 + num2;
            2'b01: temp_result <= num1 - num2;
            2'b10: temp_result <= num1 * num2;
            2'b11: temp_result <= num1 / num2;
        endcase
    end
end

assign result = temp_result;

endmodule