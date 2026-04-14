module packet_filter (
    input [31:0] src_ip,
    input [31:0] dst_ip,
    output reg allow
);
    parameter ALLOWED_SRC_IP = 32'hC0A80101; // 192.168.1.1 in hex

    always @(*) begin
        if (src_ip == ALLOWED_SRC_IP)
            allow = 1'b1; // Allow packet
        else
            allow = 1'b0; // Block packet
    end
endmodule