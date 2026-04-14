module crc_generator (
    input [7:0] data_in,
    input [7:0] polynomial,
    output reg [7:0] crc_out
);
    integer i, j;
    reg [15:0] temp;

    always @(*) begin
        temp = {8'b0, data_in}; // Append 8 zeros to the data
        for (i = 0; i < 8; i = i + 1) begin
            if (temp[15] == 1'b1) begin
                for (j = 0; j < 8; j = j + 1) begin
                    temp[j] = temp[j] ^ polynomial[j]; // XOR with polynomial
                end
            end
            temp = temp << 1; // Shift left
        end
        crc_out = temp[7:0]; // Take the lower 8 bits as CRC
    end
endmodule