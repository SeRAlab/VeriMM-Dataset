module NAT_Translation(
    input [31:0] internal_ip,
    output reg [31:0] public_ip
);
    always @(*) begin
        if (internal_ip >= 32'hC0A80000 && internal_ip <= 32'hC0A8FFFF) // 192.168.0.0 to 192.168.255.255
            public_ip = 32'hCB000001; // 203.0.113.1
        else
            public_ip = internal_ip; // Retain original IP
    end
endmodule