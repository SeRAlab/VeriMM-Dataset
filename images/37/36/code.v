module crc_generator (
    input wire clk,
    input wire rst,
    input wire [3:0] data_in,
    output reg [3:0] crc_out
);
    reg [3:0] crc_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            crc_reg <= 4'b0000;
            crc_out <= 4'b0000;
        end else begin
            crc_reg <= (crc_reg << 1) ^ (data_in ^ (crc_reg[3] ? 4'b1011 : 4'b0000));
            crc_out <= crc_reg;
        end
    end
endmodule