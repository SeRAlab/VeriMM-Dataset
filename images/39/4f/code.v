module packet_filter (
    input [7:0] src_ip,
    input [7:0] dest_ip,
    output reg permit
);
    // Allowed IP addresses
    parameter ALLOWED_SRC_IP = 8'hC0; // 192
    parameter ALLOWED_DEST_IP = 8'hA8; // 168

    always @(*) begin
        if (src_ip == ALLOWED_SRC_IP && dest_ip == ALLOWED_DEST_IP) 
            permit = 1'b1; // Permit
        else 
            permit = 1'b0; // Deny
    end
endmodule