module nat(
    input [31:0] private_ip,
    output reg [31:0] public_ip
);

reg [31:0] lookup_table [0:4];

initial begin
    // Example mappings for NAT
    lookup_table[0] = 32'hC0A80001; // 192.168.0.1
    lookup_table[1] = 32'hC0A80002; // 192.168.0.2
    lookup_table[2] = 32'hC0A80003; // 192.168.0.3
    lookup_table[3] = 32'hC0A80004; // 192.168.0.4
    lookup_table[4] = 32'hC0A80005; // 192.168.0.5
end

always @(*) begin
    public_ip = 32'hFFFFFFFF; // default to invalid IP
    case (private_ip)
        32'hC0A80001: public_ip = 32'h0A000001; // 10.0.0.1
        32'hC0A80002: public_ip = 32'h0A000002; // 10.0.0.2
        32'hC0A80003: public_ip = 32'h0A000003; // 10.0.0.3
        32'hC0A80004: public_ip = 32'h0A000004; // 10.0.0.4
        32'hC0A80005: public_ip = 32'h0A000005; // 10.0.0.5
        default: public_ip = 32'hFFFFFFFF; // invalid
    endcase
end

endmodule