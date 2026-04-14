module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output [3:0] count );reg [3:0] count_reg;

always @(posedge clk) begin
    if (reset)
        count_reg <= 4'b0000;
    else if (up_down)
        count_reg <= count_reg + 1;
    else
        count_reg <= count_reg - 1;
end

assign count = count_reg;

endmodule