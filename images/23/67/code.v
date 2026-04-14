module crc_generator (
    input clk,
    input reset,
    input [7:0] data_in,
    input data_valid,
    output reg [7:0] crc_out
);
    reg [7:0] crc;
    reg [3:0] bit_count;

    // Polynomial for CRC-8: x^8 + x^7 + x^6 + x^4 + x^3 + 1
    localparam POLYNOMIAL = 8'h1D; // 00011101 in binary

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc <= 8'hFF; // Initial value
            bit_count <= 0;
            crc_out <= 8'h00;
        end else if (data_valid && bit_count < 8) begin
            crc[7:0] <= crc[7:0] ^ data_in[7:0]; // XOR with input data
            for (bit_count = 0; bit_count < 8; bit_count = bit_count + 1) begin
                if (crc[7]) begin
                    crc <= {crc[6:0], 1'b0} ^ POLYNOMIAL; // Shift and XOR with polynomial
                end else begin
                    crc <= {crc[6:0], 1'b0}; // Just shift
                end
            end
            crc_out <= crc; // Output the CRC
            bit_count <= bit_count + 1; // Increment bit count
        end
    end
endmodule