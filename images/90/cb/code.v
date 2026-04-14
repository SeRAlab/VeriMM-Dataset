module top_module(
    input [7:0] a,
    input [7:0] b,
    input [1:0] op,
    input clk,
    output reg [7:0] result,
    output reg valid
);reg [7:0] temp_result;

always @(posedge clk) begin
    case (op)
        2'b00: temp_result = a + b; // addition
        2'b01: temp_result = a - b; // subtraction
        2'b10: temp_result = a * b; // multiplication
        2'b11: temp_result = a / b; // division
    endcase
    result <= temp_result;
    valid <= 1;
end

endmodule