module nat (
    input [31:0] private_ip,
    output reg [31:0] public_ip
);

always @* begin
    if (private_ip >= 32'hC0A80000 && private_ip <= 32'hC0A8FFFF) // 192.168.0.0 to 192.168.255.255
        public_ip = 32'hCB000001; // 203.0.113.1
    else
        public_ip = 32'h00000000; // 0.0.0.0
end

endmodule