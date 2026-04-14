module crc_generator (
    input [7:0] data_in,
    output reg [7:0] crc_out
);
    // Polynomial coefficients for x^8 + x^2 + x + 1
    parameter POLYNOMIAL = 8'b100000111;

    integer i, j;

    always @(*) begin
        crc_out = data_in; // Start with the input data
        for (i = 0; i < 8; i = i + 1) begin
            if (crc_out[7] == 1'b1) begin
                crc_out = crc_out ^ POLYNOMIAL; // XOR with polynomial
            end
            crc_out = crc_out << 1; // Shift left
        end
    end
endmodule