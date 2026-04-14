module crc_generator (
    input wire clk,
    input wire rst,
    input wire [7:0] data,
    output reg [7:0] crc
);
    reg [7:0] crc_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            crc_reg <= 8'b0;
        end else begin
            crc_reg <= crc_reg ^ data;
            crc_reg[0] = crc_reg[0] ^ crc_reg[7];
            crc_reg[1] = crc_reg[1] ^ crc_reg[7];
            crc_reg[2] = crc_reg[2] ^ crc_reg[7];
            crc_reg[3] = crc_reg[3] ^ crc_reg[7];
            crc_reg[4] = crc_reg[4] ^ crc_reg[7];
            crc_reg[5] = crc_reg[5] ^ crc_reg[7];
            crc_reg[6] = crc_reg[6] ^ crc_reg[7];
            crc_reg[7] = crc_reg[7]; // No change
        end
        crc <= crc_reg;
    end
endmodule