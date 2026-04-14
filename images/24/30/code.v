module packet_filter (
    input [31:0] src_ip,
    input [31:0] dst_ip,
    input [1:0] protocol, // 00: TCP, 01: UDP
    output reg permit
);
    always @(*) begin
        if (src_ip == 32'hC0A80101 && protocol == 2'b00) begin // 192.168.1.1
            permit = 1'b1; // Permit TCP from 192.168.1.1
        end else if (dst_ip == 32'h0A000005 && protocol == 2'b01) begin // 10.0.0.5
            permit = 1'b1; // Permit UDP to 10.0.0.5
        end else begin
            permit = 1'b0; // Deny all other packets
        end
    end
endmodule