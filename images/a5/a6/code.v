module shift_register(
    input clk,
    input ld,
    input [3:0] data,
    output reg [3:0] out);

always @(posedge clk) begin
    if (ld)
        out <= data;
    else
        out <= {out[2:0], 1'b0}; // Shift left by one bit
end

endmodule