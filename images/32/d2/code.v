module NAT(
    input clk,
    input rst,
    input [31:0] private_ip,
    output reg [31:0] public_ip
);
    reg [31:0] private_ips [0:4];
    reg [31:0] public_ips [0:4];
    integer i;
    
    initial begin
        private_ips[0] = 32'hC0A80001; // 192.168.0.1
        public_ips[0] = 32'hA1B2C3D4;   // 161.178.195.212
        private_ips[1] = 32'hC0A80002; // 192.168.0.2
        public_ips[1] = 32'hA1B2C3D5;   // 161.178.195.213
        private_ips[2] = 32'hC0A80003; // 192.168.0.3
        public_ips[2] = 32'hA1B2C3D6;   // 161.178.195.214
        private_ips[3] = 32'hC0A80004; // 192.168.0.4
        public_ips[3] = 32'hA1B2C3D7;   // 161.178.195.215
        private_ips[4] = 32'hC0A80005; // 192.168.0.5
        public_ips[4] = 32'hA1B2C3D8;   // 161.178.195.216
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            public_ip <= 32'h00000000; // Default output
        end else begin
            public_ip <= 32'h00000000; // Default output
            for (i = 0; i < 5; i = i + 1) begin
                if (private_ips[i] == private_ip) begin
                    public_ip <= public_ips[i];
                end
            end
        end
    end
endmodule