module packet_filter (
    input [4:0] src_ip,
    input [4:0] dest_ip,
    output reg allowed
);
    always @* begin
        if (src_ip == 5'b00000) begin
            allowed = 1'b0;  // Deny packets from '00000'
        end else if (dest_ip == 5'b11111) begin
            allowed = 1'b0;  // Deny packets to '11111'
        end else begin
            allowed = 1'b1;  // Allow all other packets
        end
    end
endmodule