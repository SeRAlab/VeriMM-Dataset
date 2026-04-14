module NAT (
    input [31:0] public_ip,
    output reg [31:0] private_ip
);

always @(*) begin
    case(public_ip)
        32'hC0A80001: private_ip = 32'h0A000001; // 192.168.0.1 -> 10.0.0.1
        32'hC0A80002: private_ip = 32'h0A000002; // 192.168.0.2 -> 10.0.0.2
        32'hC0A80003: private_ip = 32'h0A000003; // 192.168.0.3 -> 10.0.0.3
        32'hC0A80004: private_ip = 32'h0A000004; // 192.168.0.4 -> 10.0.0.4
        32'hC0A80005: private_ip = 32'h0A000005; // 192.168.0.5 -> 10.0.0.5
        default: private_ip = 32'hFFFFFFFF; // Default to invalid IP
    endcase
end

endmodule