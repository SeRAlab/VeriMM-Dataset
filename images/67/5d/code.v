module top_module(
    input clk,
    input rst,
    input dir,
    output reg [3:0] count);

always @(posedge clk or posedge rst) begin
    if (rst)
        count <= 4'b0000;
    else if (dir)
        count <= count + 1;
    else
        count <= count - 1;
end

endmodule