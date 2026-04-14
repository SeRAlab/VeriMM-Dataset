module crc_generator (
    input clk,
    input [3:0] data_in,
    output reg [3:0] crc_out
);
    reg [3:0] crc;

    always @(posedge clk) begin
        crc[3] <= data_in[3] ^ crc[2];
        crc[2] <= data_in[2] ^ crc[1];
        crc[1] <= data_in[1] ^ crc[0];
        crc[0] <= data_in[0];
    end

    always @(posedge clk) begin
        crc_out <= crc;
    end
endmodule