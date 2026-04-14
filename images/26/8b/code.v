module crc_4bit (
    input wire clk,
    input wire reset,
    input wire [3:0] data_in,
    output reg [2:0] crc_out
);
    reg [2:0] crc;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc <= 3'b000;
        end else begin
            crc[0] <= data_in[0] ^ crc[1] ^ crc[2];
            crc[1] <= data_in[1] ^ crc[0];
            crc[2] <= data_in[2] ^ crc[1] ^ data_in[3];
        end
    end

    always @(posedge clk) begin
        crc_out <= crc;
    end
endmodule