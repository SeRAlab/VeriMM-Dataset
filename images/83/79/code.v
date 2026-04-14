module bin_to_bcd(
    input [3:0] bin,
    output reg [7:0] bcd);
always @(*) begin
    bcd = (bin / 4'd10) * 8'd16 + (bin % 4'd10);
end
endmodule