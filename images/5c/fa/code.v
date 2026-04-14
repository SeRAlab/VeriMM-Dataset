module top_module(
    Divisor,
    clkOut,
    count,
    clk,
    rst
);input [31:0] Divisor;
output clkOut;
wire clkOut;
output [31:0] count;
wire [31:0] count;
input clk;
input rst;

reg [31:0] count_i = 0;
reg clkOut_i = 0;



always @(posedge clk, posedge rst) begin: CLOCKDIVIDER_COUNTER
    if (rst) begin
        count_i <= 0;
    end
    else if (($signed({1'b0, count_i}) == ($signed({1'b0, Divisor}) - 1))) begin
        count_i <= 0;
    end
    else begin
        count_i <= (count_i + 1);
    end
end


always @(posedge clk, posedge rst) begin: CLOCKDIVIDER_CLOCKTICK
    if (rst) begin
        clkOut_i <= 0;
    end
    else if (($signed({1'b0, count_i}) == ($signed({1'b0, Divisor}) - 1))) begin
        clkOut_i <= (!clkOut_i);
    end
    else begin
        clkOut_i <= clkOut_i;
    end
end



assign count = count_i;
assign clkOut = clkOut_i;

endmodule