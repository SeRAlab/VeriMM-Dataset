module NAT (
    input [4:0] internal_ip,
    input translate,
    output reg [4:0] public_ip
);
    always @(*) begin
        if (translate) begin
            case (internal_ip)
                5'b00000: public_ip = 5'b11111;
                5'b00001: public_ip = 5'b11110;
                5'b00010: public_ip = 5'b11101;
                5'b00011: public_ip = 5'b11100;
                5'b00100: public_ip = 5'b11011;
                default: public_ip = internal_ip; // No translation
            endcase
        end else begin
            public_ip = internal_ip; // No translation
        end
    end
endmodule