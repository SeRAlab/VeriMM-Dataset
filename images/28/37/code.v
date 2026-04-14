module nat_transform(
    input [31:0] internal_ip,
    input [31:0] external_ip,
    output reg [31:0] translated_ip
);

always @(*) begin
    case (internal_ip)
        32'hC0A80001: translated_ip = 32'h7F000001; // 192.168.0.1 -> 127.0.0.1
        32'hC0A80002: translated_ip = 32'h7F000002; // 192.168.0.2 -> 127.0.0.2
        32'hC0A80003: translated_ip = 32'h7F000003; // 192.168.0.3 -> 127.0.0.3
        32'hC0A80004: translated_ip = 32'h7F000004; // 192.168.0.4 -> 127.0.0.4
        default: translated_ip = external_ip; // No translation, return external IP
    endcase
end

endmodule