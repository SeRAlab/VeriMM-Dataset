module top_module(
    input wire clk,
    input wire rst_n,
    input wire [15:0] in,
    output reg rising_edge
);reg [15:0] in_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            in_reg <= 0;
            rising_edge <= 0;
        end else begin
            rising_edge <= (in && !in_reg);
            in_reg <= in;
        end
    end
endmodule