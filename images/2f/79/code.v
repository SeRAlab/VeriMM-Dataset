module packet_filter (
    input [31:0] src_ip,
    output reg allow
);

    always @(*) begin
        if (src_ip == 32'hC0A80101 || src_ip == 32'h0A000001) // 192.168.1.1 or 10.0.0.1
            allow = 1'b1; // Allow the packet
        else
            allow = 1'b0; // Block the packet
    end
endmodule