module crc4 (
    input [3:0] data_in,
    input clk,
    input reset,
    output reg [3:0] crc_out
);
    reg [3:0] crc;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc <= 4'b0000;
        end else begin
            crc[0] <= data_in[0] ^ crc[0] ^ crc[3];
            crc[1] <= data_in[1] ^ crc[1] ^ crc[0];
            crc[2] <= data_in[2] ^ crc[2] ^ crc[1];
            crc[3] <= data_in[3] ^ crc[3] ^ crc[2];
        end
    end

    always @(posedge clk) begin
        crc_out <= crc;
    end
endmodule