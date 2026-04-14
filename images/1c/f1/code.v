module packet_filter (
    input [31:0] src_ip,
    input [31:0] dest_ip,
    output reg allow
);
    always @(*) begin
        if (src_ip == 32'hC0A8010A && dest_ip == 32'h0A000005) // 192.168.1.10 to 10.0.0.5
            allow = 1'b1; // Allow the packet
        else
            allow = 1'b0; // Block the packet
    end
endmodule