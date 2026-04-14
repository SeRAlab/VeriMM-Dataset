module top_module(
    input clk,
    input rst,
    input en,
    input dir,
    output reg [3:0] count
);always @(posedge clk)
begin
    if (rst)
        count <= 4'b0;
    else if (en)
        count <= (dir) ? count + 1 : count - 1;
end

endmodule