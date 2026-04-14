module top_module(
input  wire clk,
input  wire rst,
output wire [3:0] count
);reg [3:0] counter_reg;

always @(posedge clk or posedge rst)
    if (rst)
        counter_reg <= 4'b0000;
    else
        counter_reg <= counter_reg + 1;

assign count = counter_reg;

endmodule