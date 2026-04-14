module packet_filter (
    input wire clk,
    input wire rst,
    input wire [15:0] packet, // 8 bits source IP, 8 bits destination IP
    output reg allow
);
    reg [15:0] rules[0:3]; // 4-entry rule memory
    reg [2:0] i;

    // Initialization of rules
    initial begin
        rules[0] = 16'hC0A80001; // Rule 1: 192.168.0.1
        rules[1] = 16'hC0A80002; // Rule 2: 192.168.0.2
        rules[2] = 16'hC0A80003; // Rule 3: 192.168.0.3
        rules[3] = 16'hC0A80004; // Rule 4: 192.168.0.4
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            allow <= 0;
        end else begin
            allow <= 0; // Assume blocked by default
            for (i = 0; i < 4; i = i + 1) begin
                if (packet == rules[i]) begin
                    allow <= 1; // Allow packet if it matches a rule
                end
            end
        end
    end
endmodule