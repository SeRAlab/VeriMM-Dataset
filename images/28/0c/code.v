module packet_filter (
    input [31:0] src_ip,
    input [31:0] dest_ip,
    input [7:0] protocol,
    output reg allow
);
    always @* begin
        // Default to blocking the packet
        allow = 0;
        
        // Allow rule
        if (src_ip == 32'hC0A8010A) begin // 192.168.1.10
            allow = 1;
        end
        // Block specific rule
        else if (src_ip == 32'hC0A80114 && dest_ip == 32'h0A000001 && protocol == 8'h06) begin // 192.168.1.20 to 10.0.0.1 using TCP (protocol 6)
            allow = 0;
        end
        // Allow all other packets
        else begin
            allow = 1;
        end
    end
endmodule