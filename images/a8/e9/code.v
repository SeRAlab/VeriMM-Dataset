module counter_12bit_by2(
    input clk,
    input reset,
    output reg [11:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset)
        count <= 12'b0;
    else
        count <= count + 2;
end

endmodule