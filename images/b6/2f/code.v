module top_module(
    input clk,
    input rst,
    input [7:0] A,
    input [7:0] B,
    input [1:0] op,
    output reg [7:0] C
);always @(posedge clk) begin
    if (rst == 1'b1) begin
        C <= 8'h00;
    end else begin
        case (op)
            2'b00: C <= A + B; // Addition
            2'b01: C <= A - B; // Subtraction
            2'b10: C <= A * B; // Multiplication
            2'b11: C <= A / B; // Division
        endcase
    end
end

endmodule