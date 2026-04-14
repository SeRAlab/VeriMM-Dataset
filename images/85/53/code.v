module counter (
    input clk,
    input async_reset,
    output [3:0] count );reg [3:0] count_reg;

always @(posedge clk or posedge async_reset) begin
    if (async_reset)
        count_reg <= 4'b0000;
    else
        count_reg <= count_reg + 1;
end

assign count = count_reg;

endmodule