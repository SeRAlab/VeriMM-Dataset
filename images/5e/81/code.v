module top_module(
    input [3:0] bin,
    input start,
    output reg [3:0] bcd
);always @ (posedge start) begin
    bcd <= 4'b0000;
    if (bin >= 5) bcd = bcd + 4'b0101;
    if (bin >= 10) bcd = bcd + 4'b0110;
    if (bin >= 15) bcd = bcd + 4'b0110;
    if (bin >= 20) bcd = bcd + 4'b0101;
    if (bin >= 25) bcd = bcd + 4'b0110;
    if (bin >= 30) bcd = bcd + 4'b0110;
    if (bin >= 35) bcd = bcd + 4'b0101;
    if (bin >= 40) bcd = bcd + 4'b0110;
    if (bin >= 45) bcd = bcd + 4'b0110;
    if (bin >= 50) bcd = bcd + 4'b0101;
end

endmodule