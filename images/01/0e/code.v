module nat (
    input [31:0] private_ip,
    output reg [31:0] public_ip
);

always @(*) begin
    case (private_ip)
        32'hC0A80101: public_ip = 32'hCB000001; // 192.168.1.1 -> 203.0.113.1
        32'hC0A80102: public_ip = 32'hCB000002; // 192.168.1.2 -> 203.0.113.2
        32'hC0A80103: public_ip = 32'hCB000003; // 192.168.1.3 -> 203.0.113.3
        32'hC0A80104: public_ip = 32'hCB000004; // 192.168.1.4 -> 203.0.113.4
        32'hC0A80105: public_ip = 32'hCB000005; // 192.168.1.5 -> 203.0.113.5
        default: public_ip = 32'h00000000; // all other IPs
    endcase
end

endmodule