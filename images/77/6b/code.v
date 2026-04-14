module top_module(
    input signed [3:0] A,
    input signed [3:0] B,
    input clk, // Added missing clk input
    output reg signed [7:0] PRODUCT,
    output OVERFLOW
);reg signed [3:0] A_reg;
reg signed [3:0] B_reg;
reg signed [7:0] PRODUCT_reg;
reg signed [7:0] temp; // Changed temp to signed to properly handle multiplication overflow

assign OVERFLOW = (PRODUCT_reg[7] != PRODUCT_reg[6]);

always @(posedge clk) begin
    A_reg <= A;
    B_reg <= B;
end

always @(posedge clk) begin
    temp <= A_reg * B_reg;
end

always @(posedge clk) begin
    PRODUCT_reg <= temp;
end

assign PRODUCT = PRODUCT_reg; // Changed to output the entire product for correct multiplication result

endmodule