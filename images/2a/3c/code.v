module crc_generator (
    input wire clk,
    input wire reset,
    input wire [3:0] data_in,
    input wire data_valid,
    output reg [2:0] crc_out,
    output reg crc_valid
);
    reg [2:0] crc;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc <= 3'b000;
            crc_out <= 3'b000;
            crc_valid <= 0;
        end else if (data_valid) begin
            crc[2] <= crc[1] ^ data_in[3];
            crc[1] <= crc[0] ^ data_in[2];
            crc[0] <= data_in[1] ^ data_in[0];
            crc_out <= crc;
            crc_valid <= 1;
        end
    end
endmodule