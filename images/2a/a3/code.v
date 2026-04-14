module nat_translate(
    input [4:0] private_ip,
    output reg [4:0] public_ip
);

    // NAT Table
    always @(*) begin
        case (private_ip)
            5'b00000: public_ip = 5'b11111; // Mapping 0 to 31
            5'b00001: public_ip = 5'b11110; // Mapping 1 to 30
            5'b00010: public_ip = 5'b11101; // Mapping 2 to 29
            5'b00011: public_ip = 5'b11100; // Mapping 3 to 28
            5'b00100: public_ip = 5'b11011; // Mapping 4 to 27
            default: public_ip = 5'b11111;   // Default case for invalid IP
        endcase
    end
endmodule