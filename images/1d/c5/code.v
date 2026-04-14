module packet_filter (
    input [31:0] src_ip,
    input [31:0] dest_ip,
    input [7:0] protocol,
    output reg [7:0] action
);
    reg [31:0] rules_src [0:3]; // Source IP rules
    reg [31:0] rules_dest [0:3]; // Destination IP rules
    reg [7:0] rules_proto [0:3]; // Protocol rules
    integer i;

    initial begin
        // Example rules
        rules_src[0] = 32'hC0A80001; // 192.168.0.1
        rules_dest[0] = 32'hC0A80002; // 192.168.0.2
        rules_proto[0] = 8'h06; // TCP

        rules_src[1] = 32'hC0A80003; // 192.168.0.3
        rules_dest[1] = 32'hC0A80004; // 192.168.0.4
        rules_proto[1] = 8'h11; // UDP

        // Other rules can be added similarly
        // Here we consider two rules for simplicity
    end

    always @(*) begin
        action = "BLOCK"; // Default action
        for (i = 0; i < 2; i = i + 1) begin
            if (src_ip == rules_src[i] && dest_ip == rules_dest[i] && protocol == rules_proto[i]) begin
                action = "ALLOW"; // Match found
            end
        end
    end
endmodule