module crc_4bit (
    input wire clk,
    input wire rst,
    input wire enable,
    input wire [3:0] data_in,
    input wire [3:0] poly,
    output reg [3:0] crc_out
);
    reg [3:0] crc_reg;
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            crc_reg <= 4'b0000;
            crc_out <= 4'b0000;
        end else if (enable) begin
            crc_reg <= data_in; // Initial load of data
            for (i = 0; i < 4; i = i + 1) begin
                if (crc_reg[3] == 1'b1) begin
                    crc_reg <= (crc_reg << 1) ^ poly; // Shift and XOR with polynomial
                end else begin
                    crc_reg <= crc_reg << 1; // Just shift
                end
            end
            crc_out <= crc_reg; // Output the CRC value
        end
    end
endmodule