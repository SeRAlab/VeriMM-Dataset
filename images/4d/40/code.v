module top_module (
    input clk,
    input areset,
    input count_enable,
    input up,
    input down,
    output [15:0] count );reg [15:0] count_reg;

always @(posedge clk or posedge areset) begin
    if (areset)
        count_reg <= 16'b0000000000000000;
    else if (count_enable) begin
        if (up)
            count_reg <= count_reg + 1;
        else if (down)
            count_reg <= count_reg - 1;
    end
end

assign count = count_reg;

endmodule