module nat_ipv4 (
    input [31:0] private_ip,
    output reg [31:0] public_ip
);
    // Predefined mapping table
    reg [31:0] private_table[0:4]; // 5 entries
    reg [31:0] public_table[0:4]; // 5 corresponding public IPs
    integer i;
    initial begin
        // Initialize the mapping table
        private_table[0] = 32'hC0A80101; // 192.168.1.1
        public_table[0] = 32'h0A000001; // 10.0.0.1

        private_table[1] = 32'hC0A80102; // 192.168.1.2
        public_table[1] = 32'h0A000002; // 10.0.0.2

        private_table[2] = 32'hC0A80103; // 192.168.1.3
        public_table[2] = 32'h0A000003; // 10.0.0.3

        private_table[3] = 32'hC0A80104; // 192.168.1.4
        public_table[3] = 32'h0A000004; // 10.0.0.4

        private_table[4] = 32'hC0A80105; // 192.168.1.5
        public_table[4] = 32'h0A000005; // 10.0.0.5
    end

    always @(*) begin
        public_ip = 32'h00000000; // default public IP
        for (i = 0; i < 5; i = i + 1) begin
            if (private_ip == private_table[i]) begin
                public_ip = public_table[i];
            end
        end
    end
endmodule