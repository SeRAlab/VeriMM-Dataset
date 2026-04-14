module top_module(
    input clk,
    input rst,
    input select,
    input [15:0] in0,
    input [15:0] in1,
    output reg [15:0] count,
    output reg [15:0] product
);reg [15:0] count_reg;
reg [15:0] product_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count_reg <= 16'h0;
        product_reg <= 16'h0;
    end else begin
        if (select) begin
            product_reg <= shift_and_add(in0, in1);
        end else begin
            count_reg <= count_reg + 16'h1;
        end
    end
end

assign count = count_reg;
assign product = product_reg;

function [15:0] shift_and_add;
    input [15:0] a, b;
    reg [15:0] result;
    reg [15:0] temp;
    integer i;
begin
    result = 16'h0;
    temp = a;
    for (i = 0; i < 16; i = i + 1) begin
        if (b[i]) begin
            result = result + temp;
        end
        temp = temp << 1;
    end
    shift_and_add = result;
end
endfunction

endmodule