module nat_translation (
    input [31:0] private_ip,
    output reg [31:0] public_ip
);
    always @(*) begin
        case (private_ip)
            32'hC0A80001: public_ip = 32'hA1B2C3D4; // 192.168.0.1 to 161.178.195.212
            32'hC0A80002: public_ip = 32'hA1B2C3D5; // 192.168.0.2 to 161.178.195.213
            32'hC0A80003: public_ip = 32'hA1B2C3D6; // 192.168.0.3 to 161.178.195.214
            32'hC0A80004: public_ip = 32'hA1B2C3D7; // 192.168.0.4 to 161.178.195.215
            default: public_ip = 32'h00000000; // Invalid IP
        endcase
    end
endmodule