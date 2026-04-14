module top_module (
    input clk,
    input areset,
    input count_enable,
    input up_down,
    output [3:0] count );reg [3:0] count_reg;

always @(posedge clk or posedge areset) begin
    if (areset)
        count_reg <= 4'b0000;
    else if (count_enable) begin
        if (up_down)
            count_reg <= count_reg + 1;
        else
            count_reg <= count_reg - 1;
    end
end

assign count = count_reg;

endmodule