module top_module(
    input clk,
    input reset,
    input [7:0] num1,
    input [7:0] num2,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output [7:0] sum,
    output reg [99:0] rot
);reg [7:0] sum_reg;
reg [7:0] num1_reg;
reg [7:0] num2_reg;
reg [99:0] rot_reg;
reg [99:0] shifted_data; // Change size to match rot_reg

always @(posedge clk) begin
    if (reset) begin
        sum_reg <= 8'b0;
        num1_reg <= 8'b0;
        num2_reg <= 8'b0;
        rot_reg <= 100'b0;
        shifted_data <= 100'b0; // Change size to match rot_reg
    end else begin
        if (load) begin
            num1_reg <= num1;
            num2_reg <= num2;
        end
        sum_reg <= num1_reg + num2_reg;
        if (ena[0]) begin
            shifted_data[7:0] <= data[99:92]; // Assign to the lower part
            shifted_data[99:8] <= rot_reg[99:1]; // Assign the upper part correctly
            rot_reg <= shifted_data;
        end
    end
end

assign sum = sum_reg;
assign rot = rot_reg;

endmodule