module top_module(
    input clk,
    input rst,
    input en,
    output [3:0] count
);reg [3:0] count_reg;

    always @(posedge clk) begin
        if (rst) begin
            count_reg <= 4'b0;
        end else if (en) begin
            count_reg <= count_reg + 1;
        end
    end

    assign count = count_reg;

endmodule