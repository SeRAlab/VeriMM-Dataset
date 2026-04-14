module NAT(
    input [31:0] src_ip,
    input [31:0] dest_ip,
    output reg [31:0] translated_src_ip,
    output reg [31:0] translated_dest_ip
);
    always @(*) begin
        case (src_ip)
            32'hC0A8010A: translated_src_ip = 32'h0A00000A; // 192.168.1.10 -> 10.0.0.10
            default: translated_src_ip = src_ip;
        endcase

        case (dest_ip)
            32'hAC100014: translated_dest_ip = 32'h0A000014; // 172.16.0.20 -> 10.0.0.20
            default: translated_dest_ip = dest_ip;
        endcase
    end
endmodule