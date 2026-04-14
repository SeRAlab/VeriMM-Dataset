module NAT (
    input [31:0] src_ip,
    input [31:0] dest_ip,
    output reg [31:0] translated_src_ip
);

    always @(*) begin
        case (src_ip)
            32'hC0A80001: translated_src_ip = 32'hC0A80002; // 192.168.0.1 -> 192.168.0.2
            32'hC0A80002: translated_src_ip = 32'hC0A80003; // 192.168.0.2 -> 192.168.0.3
            32'hC0A80003: translated_src_ip = 32'hC0A80004; // 192.168.0.3 -> 192.168.0.4
            32'hC0A80004: translated_src_ip = 32'hC0A80005; // 192.168.0.4 -> 192.168.0.5
            default: translated_src_ip = src_ip; // No translation
        endcase
    end
endmodule