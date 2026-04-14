module nat(
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [31:0] internal_ip,
    output reg [31:0] external_ip
);

    reg [31:0] internal_map[0:4]; // Array to hold internal IPs
    reg [31:0] external_map[0:4]; // Array to hold external IPs
    integer i;

    initial begin
        // Initialize the mappings for NAT
        internal_map[0] = 32'hC0A80001; // 192.168.0.1
        external_map[0] = 32'hA0A80001; // 160.168.0.1

        internal_map[1] = 32'hC0A80002; // 192.168.0.2
        external_map[1] = 32'hA0A80002; // 160.168.0.2

        internal_map[2] = 32'hC0A80003; // 192.168.0.3
        external_map[2] = 32'hA0A80003; // 160.168.0.3

        internal_map[3] = 32'hC0A80004; // 192.168.0.4
        external_map[3] = 32'hA0A80004; // 160.168.0.4

        internal_map[4] = 32'hC0A80005; // 192.168.0.5
        external_map[4] = 32'hA0A80005; // 160.168.0.5
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            external_ip <= 32'b0;
        end else if (enable) begin
            external_ip <= 32'b0; // Default to zero
            for (i = 0; i < 5; i = i + 1) begin
                if (internal_ip == internal_map[i]) begin
                    external_ip <= external_map[i];
                end
            end
        end else begin
            external_ip <= internal_ip; // If not enabled, output internal IP
        end
    end
endmodule