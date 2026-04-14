module up_down_counter(
    input  clk,
    input  reset,
    input  dir,
    output [3:0] count
);

reg [3:0] count_reg;

always @(posedge clk) begin
    if (reset) begin
        count_reg <= 4'b0000;
    end else if (dir) begin
        count_reg <= count_reg + 1;
    end else begin
        count_reg <= count_reg - 1;
    end
end

assign count = count_reg;

endmodule