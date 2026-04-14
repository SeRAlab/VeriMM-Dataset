module crc_3bit (
    input clk,
    input rst,
    input [3:0] data_in,
    input data_valid,
    output reg [2:0] crc_out
);
    reg [2:0] crc;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            crc <= 3'b000;
            crc_out <= 3'b000;
        end else if (data_valid) begin
            crc[2] <= crc[1] ^ data_in[3];
            crc[1] <= crc[0] ^ data_in[2];
            crc[0] <= data_in[1] ^ data_in[0];
            crc_out <= crc;
        end
    end
endmodule