module crc_generator (
    input clk,
    input reset,
    input [7:0] data,
    output reg [7:0] crc);always @(posedge clk) begin
    if (reset) begin
        crc <= 8'b0;
    end else begin
        crc <= {crc[6:0], crc[7] ^ data[7]};
    end
end
endmodule