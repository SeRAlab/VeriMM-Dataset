module crc_generator (
    input [7:0] data_in,
    input [3:0] polynomial,
    output reg [3:0] crc_out,
    input clk,
    input rst
);
    reg [7:0] shift_reg;
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 8'b0;
            crc_out <= 4'b0;
        end else begin
            shift_reg <= data_in;
            crc_out <= 4'b0; // Reset CRC output
            for (i = 0; i < 8; i = i + 1) begin
                if (shift_reg[7]) begin
                    shift_reg <= (shift_reg << 1) ^ polynomial;
                end else begin
                    shift_reg <= shift_reg << 1;
                end
            end
            crc_out <= shift_reg[3:0]; // Take the last 4 bits as CRC
        end
    end
endmodule