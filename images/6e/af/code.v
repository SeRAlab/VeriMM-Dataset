module counter_3bit(
    input clk,
    input enable,
    output reg [2:0] count
);

always @(posedge clk) begin
    if (enable)
        count <= count + 1;
end

endmodule