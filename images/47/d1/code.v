module top_module(
    input clk,
    output [3:0] count
);reg [3:0] count_reg = 4'b0000;

always @(posedge clk) begin
    if (count_reg == 4'b1111) begin
        count_reg <= 4'b0000;
    end else begin
        count_reg <= count_reg + 1;
    end
end

assign count = count_reg;

endmodule