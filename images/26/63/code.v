module crc_generator (
    input wire [3:0] data,
    input wire clk,
    output reg [3:0] crc
);
    reg [3:0] crc_reg;

    always @(posedge clk) begin
        crc_reg[0] <= data[0] ^ crc_reg[3];
        crc_reg[1] <= data[1] ^ crc_reg[0];
        crc_reg[2] <= data[2] ^ crc_reg[1];
        crc_reg[3] <= data[3] ^ crc_reg[2];

        crc <= crc_reg;
    end

    initial begin
        crc_reg = 4'b0000;
    end
endmodule