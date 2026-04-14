module top_module(
    input clk, rst, en,
    output reg [3:0] count,
    output reg max
);always @(posedge clk, posedge rst)
begin
    if (rst)
        count <= 4'b0;
    else if (en)
        count <= count + 1;
end

assign max = (count == 4'b1111);

endmodule