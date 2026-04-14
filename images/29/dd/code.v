module crc_generator (
    input [7:0] data_in,
    output [7:0] crc_out
);
    wire [15:0] data_with_crc;
    assign data_with_crc = {data_in, 8'b0}; // Append 8 zeros to the input data

    reg [15:0] crc;
    integer i;

    always @(*) begin
        crc = data_with_crc;
        for (i = 0; i < 8; i = i + 1) begin
            if (crc[15]) begin
                crc = crc ^ 16'hB8; // Polynomial: x^8 + x^7 + x^4 + 1 (0b10111000)
            end
            crc = crc << 1; // Shift left
        end
    end

    assign crc_out = crc[7:0]; // Output the CRC

endmodule