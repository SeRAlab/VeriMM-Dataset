module shift_register8bit(
    input [7:0] data,
    input dir,
    input clk,
    output reg [7:0] q
);always @(posedge clk) begin
    if (dir) q <= data >> 1;
    else q <= data << 1;
end

endmodule