module nat (
    input [31:0] private_ip,
    output reg [31:0] public_ip
);
    always @(*) begin
        case (private_ip)
            32'b11000000101010000000000100000001: public_ip = 32'b11001111000000000000000000000001; // 192.168.1.1 -> 203.0.113.1
            32'b11000000101010000000000100000010: public_ip = 32'b11001111000000000000000000000010; // 192.168.1.2 -> 203.0.113.2
            default: public_ip = private_ip; // unchanged
        endcase
    end
endmodule