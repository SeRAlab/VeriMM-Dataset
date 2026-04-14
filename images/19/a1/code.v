module packet_filter (
    input [31:0] src_ip,
    input [15:0] dest_port,
    output reg allowed
);
    // Define allowed source IPs
    parameter IP1 = 32'hC0A80101; // 192.168.1.1
    parameter IP2 = 32'hC0A80102; // 192.168.1.2
    parameter ALLOWED_PORT = 16'd80;

    always @(*) begin
        if ((src_ip == IP1 || src_ip == IP2) && (dest_port == ALLOWED_PORT)) begin
            allowed = 1;
        end else begin
            allowed = 0;
        end
    end
endmodule