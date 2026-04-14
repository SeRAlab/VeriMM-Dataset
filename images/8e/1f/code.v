module up_down_counter_3bit
(
    input clk,
    input dir,
    output reg [2:0] count
);

always @(posedge clk)
begin
    if (dir)
        count <= count + 1;
    else
        count <= count - 1;
end

endmodule