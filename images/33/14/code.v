module crc_generator (
    input wire clk,
    input wire [7:0] data_in,
    input wire [3:0] polynomial,
    output reg [3:0] crc_out
);
    reg [7:0] data_reg;
    reg [3:0] crc_reg;
    
    always @(posedge clk) begin
        data_reg <= data_in;
        crc_reg <= data_reg[7:4] ^ polynomial; // Simple XOR operation for CRC
        crc_out <= crc_reg;
    end
endmodule