module crc_calculator (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [7:0] data_in,
    output reg [3:0] crc_out,
    output reg ready
);
    reg [3:0] crc;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc <= 4'b0000;
            ready <= 0;
        end else if (enable) begin
            crc <= 4'b0000; // Reset CRC for new calculation
            for (i = 0; i < 8; i = i + 1) begin
                crc[3] <= crc[2] ^ data_in[i];
                crc[2] <= crc[1];
                crc[1] <= crc[0];
                crc[0] <= crc[3] ^ data_in[i];
            end
            crc_out <= crc;
            ready <= 1; // Indicate CRC is ready
        end
    end
endmodule