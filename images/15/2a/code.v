module PacketFilter(
    input [31:0] src_ip,
    input [15:0] dest_port,
    input enable,
    output reg allowed
);

    // Define allowed IP and port range
    parameter ALLOWED_IP = 32'hC0A80001; // 192.168.0.1
    parameter MIN_PORT = 16'd80; // HTTP
    parameter MAX_PORT = 16'd100; // Example upper port limit

    always @(*) begin
        if (enable) begin
            if (src_ip == ALLOWED_IP && (dest_port >= MIN_PORT && dest_port <= MAX_PORT))
                allowed = 1;
            else
                allowed = 0;
        end else begin
            allowed = 0; // if not enabled, block all
        end
    end
endmodule