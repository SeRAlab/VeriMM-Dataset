module NAT (
    input wire clk,
    input wire reset,
    input wire [31:0] local_ip,
    input wire [15:0] local_port,
    input wire control,
    output reg [31:0] public_ip,
    output reg [15:0] public_port
);
    reg [31:0] ip_table [0:3]; // 4 entries for simplicity
    reg [15:0] port_table [0:3];
    reg [1:0] index;

    // Initialize the NAT table
    initial begin
        ip_table[0] = 32'hC0A80001; // 192.168.0.1
        port_table[0] = 16'h1F90;    // 8080
        ip_table[1] = 32'hC0A80002; // 192.168.0.2
        port_table[1] = 16'h1F91;    // 8081
        ip_table[2] = 32'hC0A80003; // 192.168.0.3
        port_table[2] = 16'h1F92;    // 8082
        ip_table[3] = 32'hC0A80004; // 192.168.0.4
        port_table[3] = 16'h1F93;    // 8083
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            public_ip <= 32'b0;
            public_port <= 16'b0;
        end else if (control) begin
            public_ip <= ip_table[index];
            public_port <= port_table[index];
            index <= (index + 1) % 4; // Cycle through the entries
        end
    end
endmodule