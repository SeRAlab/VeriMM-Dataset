module packet_filter (
    input [31:0] src_ip,
    input [31:0] dest_ip,
    input [2:0] proto,
    output reg permit,
    output reg deny
);

always @(*) begin
    if (src_ip == 32'hC0A80101 && dest_ip == 32'h0A000001 && proto == 3'b001) begin
        permit = 1;
        deny = 0;
    end else begin
        permit = 0;
        deny = 1;
    end
end

endmodule