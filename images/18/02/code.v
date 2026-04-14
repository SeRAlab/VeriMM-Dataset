module nat_device (
    input [31:0] incoming_ip,
    input translate,
    output reg [31:0] outgoing_ip
);

    always @(posedge translate) begin
        case (incoming_ip)
            32'hC0A80101: outgoing_ip <= 32'h0A000001; // 192.168.1.1 to 10.0.0.1
            32'hC0A80102: outgoing_ip <= 32'h0A000002; // 192.168.1.2 to 10.0.0.2
            default: outgoing_ip <= incoming_ip; // Pass through
        endcase
    end
endmodule