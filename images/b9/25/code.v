module top_module(
    input clk,
    input reset,
    input signed [7:0] A,
    input signed [7:0] B,
    input [1:0] op,
    output reg signed [15:0] result, // Change output to reg
    output valid
);reg signed [15:0] temp;
reg valid_reg;

always @(*) begin
    case(op)
        2'b00: temp = A + B; // addition
        2'b01: temp = A - B; // subtraction
        2'b10: temp = A * B; // multiplication
        2'b11: temp = A / B; // division
        default: temp = 16'b0; // default to 0
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        valid_reg <= 1'b0;
        result <= 16'b0;
    end else begin
        result <= temp;
        valid_reg <= 1'b1;
    end
end

assign valid = valid_reg;

endmodule