module packet_filter (
    input [31:0] src_ip,
    input [31:0] dst_ip,
    output reg allow
);
    always @(*) begin
        if (src_ip == 32'hC0A80101 && dst_ip == 32'h0A000001) // 192.168.1.1 and 10.0.0.1
            allow = 1'b1; // Allow
        else
            allow = 1'b0; // Block
    end
endmodule