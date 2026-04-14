module top_module(
    input clk,
    input load,
    input [3:0] data_in,
    input [3:0] num1,
    input [3:0] num2,
    output [3:0] q,
    output reg [3:0] larger,
    output reg [7:0] sum
);reg [3:0] shift_reg;

// Shift Register implementation
always @(posedge clk) begin
    if (load) begin
        shift_reg <= data_in;
    end else begin
        shift_reg <= {shift_reg[2:0], 1'b0}; // Example for shifting right
    end
end

// Larger Number Logic
always @(*) begin
    if (num1 > num2)
        larger = num1;
    else
        larger = num2;
end

assign q = shift_reg; // Output the shifted value

always @(posedge clk) begin
    sum <= larger + shift_reg;
end

endmodule