module nat (
    input wire clk,
    input wire rst,
    input wire [31:0] internal_ip,    // Internal IP address input
    output reg [31:0] external_ip      // External IP address output
);

    reg [31:0] ip_table [0:4];         // NAT mapping table
    reg [31:0] default_external_ip;     // Default external IP address
    integer i;

    initial begin
        // Initialize the NAT mapping table
        ip_table[0] = 32'hC0A80001; // 192.168.0.1
        ip_table[1] = 32'hC0A80002; // 192.168.0.2
        ip_table[2] = 32'hC0A80003; // 192.168.0.3
        ip_table[3] = 32'hC0A80004; // 192.168.0.4
        ip_table[4] = 32'hC0A80005; // 192.168.0.5
        default_external_ip = 32'h7F000001; // 127.0.0.1
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            external_ip <= default_external_ip; // Reset to default on rst
        end else begin
            external_ip <= default_external_ip; // Default output
            for (i = 0; i < 5; i = i + 1) begin
                if (internal_ip == ip_table[i]) begin
                    external_ip <= 32'hAABBCCDD; // Example external IP
                end
            end
        end
    end

endmodule