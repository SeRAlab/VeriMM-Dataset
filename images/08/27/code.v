module crc_calculator(
    input clk,
    input reset,
    input enable,
    input [7:0] data_in,
    output reg [3:0] crc_out
);
    reg [3:0] polynomial = 4'b1011; // Example polynomial
    reg [7:0] data_reg;
    reg [3:0] crc_reg;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc_out <= 4'b0000;
            data_reg <= 8'b00000000;
            crc_reg <= 4'b0000;
        end else if (enable) begin
            data_reg <= data_in;
            crc_reg <= 4'b0000; // Reset CRC for new calculation
            for (i = 0; i < 8; i = i + 1) begin
                crc_reg = {crc_reg[2:0], data_reg[7-i]} ^ (crc_reg[3] ? polynomial : 4'b0000);
            end
            crc_out <= crc_reg;
        end
    end
endmodule