module top_module(
    input clk,
    input rst,
    input s_in,
    output reg [3:0] q);

always @(posedge clk or posedge rst) begin
    if (rst)
        q <= 4'b0000;
    else
        q <= {q[2:0], s_in};
end

endmodule