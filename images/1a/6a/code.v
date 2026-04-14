module packet_filter (
    input [31:0] src_ip,
    input [15:0] dest_port,
    output reg allow
);

    // Define the allowed source IP and destination port.
    parameter ALLOWED_SRC_IP = 32'hC0A80001; // 192.168.0.1
    parameter ALLOWED_DEST_PORT = 16'h1F90;   // 8080

    always @(*) begin
        if (src_ip == ALLOWED_SRC_IP && dest_port == ALLOWED_DEST_PORT) 
            allow = 1'b1;  // Allow the packet
        else 
            allow = 1'b0;  // Deny the packet
    end
endmodule