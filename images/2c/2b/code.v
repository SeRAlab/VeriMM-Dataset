module nat (
    input clk,
    input reset,
    input [31:0] private_ip,
    input valid,
    output reg [31:0] public_ip
);
    // Define a simple NAT mapping
    reg [31:0] nat_table [0:3]; // A simple NAT table with 4 entries
    initial begin
        nat_table[0] = 32'hC0A80001; // 192.168.0.1
        nat_table[1] = 32'hC0A80002; // 192.168.0.2
        nat_table[2] = 32'hC0A80003; // 192.168.0.3
        nat_table[3] = 32'hC0A80004; // 192.168.0.4
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            public_ip <= 32'b0; // Reset public IP to 0
        end else if (valid) begin
            case (private_ip)
                nat_table[0]: public_ip <= 32'hA0A80001; // 160.168.0.1
                nat_table[1]: public_ip <= 32'hA0A80002; // 160.168.0.2
                nat_table[2]: public_ip <= 32'hA0A80003; // 160.168.0.3
                nat_table[3]: public_ip <= 32'hA0A80004; // 160.168.0.4
                default: public_ip <= 32'b0; // Unknown private IP
            endcase
        end
    end
endmodule