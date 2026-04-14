module top_module(
    input clk, ce, rst,
    input [13:0] in,
    output reg [22:0] out
);reg [22:0] sum;

always @(posedge clk) begin
    if (rst) begin
        sum <= 0;
        out <= 0;
    end
    else if (ce) begin
        sum <= sum + in;
        out <= sum;
    end
end

endmodule