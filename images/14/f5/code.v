module packet_filter (
    input [31:0] source_ip,
    output reg allowed
);
    always @(*) begin
        case (source_ip)
            32'hC0A80101: allowed = 1; // 192.168.1.1
            32'h0A000001: allowed = 1; // 10.0.0.1
            32'hAC100001: allowed = 1; // 172.16.0.1
            default: allowed = 0; // Block all others
        endcase
    end
endmodule