module top_module(
    input clk,
    input rst,
    input [31:0] div_val,
    output reg clk_out
    );reg [31:0] clk_temp;

always @(posedge clk or negedge rst) begin

if (!rst) begin
    clk_temp = 0;
    clk_out = 0;
end else begin
    if (clk_temp >= div_val) begin 
        clk_out <= ~clk_out; 
        clk_temp <= 0;
    end else begin
        clk_temp <= clk_temp + 1;
    end
end 
end 
endmodule