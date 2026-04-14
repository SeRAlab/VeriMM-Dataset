module packet_filter (
    input [4:0] src_ip,
    input [4:0] dest_ip,
    output reg accept
);

always @(*) begin
    if ((src_ip >= 5'b00000 && src_ip <= 5'b01111) && (dest_ip == 5'b10101)) 
        accept = 1'b1; // Accept the packet
    else 
        accept = 1'b0; // Reject the packet
end

endmodule