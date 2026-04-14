module crc_generator (
    input wire clk,
    input wire reset,
    input wire [3:0] data_in,
    output reg [3:0] crc_out
);
    reg [3:0] crc_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc_reg <= 4'b0000;
        end else begin
            crc_reg[3] <= data_in[3] ^ crc_reg[2];
            crc_reg[2] <= data_in[2] ^ crc_reg[1];
            crc_reg[1] <= data_in[1] ^ crc_reg[0];
            crc_reg[0] <= data_in[0];
        end
    end

    always @(posedge clk) begin
        crc_out <= crc_reg;
    end
endmodule