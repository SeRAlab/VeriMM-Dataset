module nat (
    input wire clk,
    input wire rst,
    input wire [31:0] internal_ip,
    input wire [15:0] internal_port,
    input wire [31:0] external_ip,
    output reg [15:0] external_port
);
    reg [31:0] ip_table [0:3];
    reg [15:0] port_table [0:3];
    reg [1:0] next_entry;
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 4; i = i + 1) begin
                ip_table[i] <= 32'b0;
                port_table[i] <= 16'b0;
            end
            next_entry <= 2'b00;
            external_port <= 16'b0;
        end else begin
            // Simple mapping logic
            if (next_entry < 4) begin
                ip_table[next_entry] <= internal_ip;
                port_table[next_entry] <= internal_port;
                external_port <= port_table[next_entry] + 1; // Incrementing port for simplicity
                next_entry <= next_entry + 1;
            end else begin
                external_port <= 16'b0; // If table is full, output zero
            end
        end
    end
endmodule