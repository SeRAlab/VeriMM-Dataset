module NAT (
    input clk,
    input rst,
    input [31:0] private_ip,
    output reg [31:0] public_ip
);
    reg [31:0] ip_mapping [0:3]; // Mapping for 4 private IPs

    initial begin
        ip_mapping[0] = 32'hC0A80001; // 192.168.0.1
        ip_mapping[1] = 32'hC0A80002; // 192.168.0.2
        ip_mapping[2] = 32'hC0A80003; // 192.168.0.3
        ip_mapping[3] = 32'hC0A80004; // 192.168.0.4
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            public_ip <= 32'b0;
        end else begin
            case(private_ip)
                32'hC0A80001: public_ip <= 32'hAABBCC01; // Mapping to a public IP
                32'hC0A80002: public_ip <= 32'hAABBCC02;
                32'hC0A80003: public_ip <= 32'hAABBCC03;
                32'hC0A80004: public_ip <= 32'hAABBCC04;
                default: public_ip <= 32'b0; // Default case
            endcase
        end
    end
endmodule