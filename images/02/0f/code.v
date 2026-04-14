module crc_generator (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    output reg [7:0] crc_out
);
    reg [7:0] crc_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc_reg <= 8'b0;
            crc_out <= 8'b0;
        end else begin
            crc_reg <= crc_reg ^ data_in;
            crc_out <= crc_reg;
            // CRC calculation based on polynomial x^8 + x^2 + x + 1 (0x07)
            if (crc_reg[7]) begin
                crc_reg <= (crc_reg << 1) ^ 8'h07;
            end else begin
                crc_reg <= crc_reg << 1;
            end
        end
    end
endmodule