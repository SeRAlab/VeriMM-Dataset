module CRC_Generator (
    input wire clk,
    input wire rst,
    input wire valid,
    input wire [7:0] data_in,
    input wire [3:0] polynomial,
    output reg [3:0] crc_out
);
    reg [7:0] shift_reg;
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            crc_out <= 4'b0;
            shift_reg <= 8'b0;
        end else if (valid) begin
            shift_reg <= data_in;
            crc_out <= 4'b0; // Initialize CRC output
            for (i = 0; i < 8; i = i + 1) begin
                if (shift_reg[7] ^ crc_out[3]) begin
                    crc_out <= (crc_out << 1) ^ polynomial;
                end else begin
                    crc_out <= (crc_out << 1);
                end
                shift_reg <= shift_reg << 1;
            end
        end
    end
endmodule