module top_module(
    input [7:0] A,
    input [7:0] B,
    input clk,
    input reset,
    output reg [7:0] sum,
    output reg overflow,
    output reg negative,
    output reg unsigned_flag  // Changed name from 'unsigned' to 'unsigned_flag'
);reg [7:0] sum_reg;

    always @(posedge clk) begin
        if (reset) begin
            sum_reg <= 8'b0;
            overflow <= 1'b0;
            negative <= 1'b0;
            unsigned_flag <= 1'b0; // Changed name from 'unsigned' to 'unsigned_flag'
        end else begin
            sum_reg <= A + B;
            overflow <= (sum_reg > 8'hff);
            negative <= sum_reg[7]; // Based on the sum, not A or B
            unsigned_flag <= ~(A[7] & B[7]); // Changed name from 'unsigned' to 'unsigned_flag'
        end
    end

    assign sum = sum_reg;

endmodule