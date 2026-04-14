module packet_filter (
    input [15:0] src_ip,
    input [15:0] dest_ip,
    output reg allowed
);

always @(*) begin
    if ((src_ip >= 16'hC0A80100 && src_ip <= 16'hC0A801FF) && 
        (dest_ip >= 16'h0A000000 && dest_ip <= 16'h0A0000FF)) begin
        allowed = 1'b1; // Packet allowed
    end else begin
        allowed = 1'b0; // Packet blocked
    end
end

endmodule