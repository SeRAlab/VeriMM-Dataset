module packet_filter(
    input [7:0] src_ip,
    input [7:0] dest_ip,
    input [1:0] protocol,
    output reg accept
);
    always @(*) begin
        if ((src_ip == 8'hAA && dest_ip == 8'hBB && protocol == 2'b00) ||
            (src_ip == 8'hCC && dest_ip == 8'hDD && protocol == 2'b01)) 
        begin
            accept = 1'b1; // Accept the packet
        end else begin
            accept = 1'b0; // Reject the packet
        end
    end
endmodule