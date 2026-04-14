module top_module(
    input [3:0] A,
    input [3:0] B,
    input sub,
    input clk,           // Added clk input
    output reg [3:0] sum, // Changed output to reg
    output reg carry_out  // Changed output to reg
);reg [3:0] A_reg, B_reg;
reg carry_in_reg;

always @(posedge clk) begin
    A_reg <= A;
    B_reg <= B;
    carry_in_reg <= sub ? 1'b1 : 1'b0; // carry_in_reg is set based on sub
    if(sub) begin
        {carry_out, sum} <= A_reg + (~B_reg + 1); // Perform subtraction
    end else begin
        {carry_out, sum} <= A_reg + B_reg; // Perform addition
    end
end

endmodule