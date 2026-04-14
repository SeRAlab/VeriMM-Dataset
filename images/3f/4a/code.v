module crc_generator(
    input [7:0] data_in,
    output reg [7:0] crc_out
);
    integer i;
    reg [15:0] shift_reg;
    reg [7:0] polynomial = 8'hA3; // 0b10100011

    always @(*) begin
        shift_reg = {data_in, 8'b0}; // Initialize shift register with input data
        for (i = 0; i < 8; i = i + 1) begin
            if (shift_reg[15]) // If MSB is set
                shift_reg = shift_reg ^ {polynomial, 8'b0}; // XOR with polynomial
            shift_reg = shift_reg << 1; // Shift left
        end
        crc_out = shift_reg[7:0]; // Output the CRC
    end
endmodule