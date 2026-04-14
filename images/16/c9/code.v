module NAT (
    input [31:0] private_ip,
    output reg [31:0] public_ip
);
    always @(*) begin
        if (private_ip >= 32'hC0A80100 && private_ip <= 32'hC0A801FF) begin
            public_ip = private_ip + 32'hC000007; // Mapping to public IP (203.0.113.x)
        end else begin
            public_ip = 32'hFFFFFFFF; // Unknown IP mapping
        end
    end
endmodule