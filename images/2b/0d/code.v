module packet_filter (
    input clk,
    input rst,
    input [31:0] src_ip,      // Source IP address
    input [15:0] dest_port,   // Destination port
    output reg allowed         // Output: 1 if allowed, 0 if blocked
);

    parameter ALLOWED_SRC_IP = 32'hC0A80164; // 192.168.1.100
    parameter ALLOWED_DEST_PORT = 16'd8080;   // 8080

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            allowed <= 0; // Reset output
        end else begin
            if (src_ip == ALLOWED_SRC_IP && dest_port == ALLOWED_DEST_PORT) begin
                allowed <= 1; // Allow packet
            end else begin
                allowed <= 0; // Block packet
            end
        end
    end

endmodule