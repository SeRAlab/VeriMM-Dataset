module crc_generator (
    input wire clk,
    input wire rst,
    input wire [3:0] data_in,
    output reg [3:0] crc_out
);
    reg [3:0] crc;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            crc <= 4'b0000;
            crc_out <= 4'b0000;
        end else begin
            crc[3] <= data_in[3] ^ crc[0];
            crc[2] <= data_in[2] ^ crc[3];
            crc[1] <= data_in[1] ^ crc[2];
            crc[0] <= data_in[0] ^ crc[1];
            crc_out <= crc;
        end
    end
endmodule