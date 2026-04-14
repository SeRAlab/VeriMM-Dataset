module bcd_counter (
    input clk,
    input clear,
    output reg [3:0] bcd
);
always @(posedge clk) begin
    if (clear)
        bcd <= 4'b0000;
    else if (bcd == 4'b1001)
        bcd <= 4'b0000;
    else
        bcd <= bcd + 1;
end

endmodule