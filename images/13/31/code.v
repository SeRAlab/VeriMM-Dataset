module packet_filter (
    input [15:0] packet,
    output reg allow
);

    wire [3:0] src_addr = packet[15:12];
    wire [3:0] dst_addr = packet[11:8];
    wire [7:0] protocol = packet[7:0];

    always @(*) begin
        if (src_addr == 4'b1010) begin // 0xAAAA
            allow = 0; // Block
        end else if (dst_addr == 4'b0001) begin // 0x1234
            allow = 1; // Allow
        end else if (protocol == 8'b00000001) begin // Protocol type 0x01
            allow = 0; // Block
        end else begin
            allow = 1; // Allow all other packets
        end
    end

endmodule