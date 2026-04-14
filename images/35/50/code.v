module crc4 (
    input wire [3:0] data_in,
    input wire clk,
    output reg [3:0] crc_out
);
    reg [3:0] crc_reg;
    
    always @(posedge clk) begin
        crc_reg <= crc_reg ^ data_in; // XOR the incoming data with CRC
        crc_reg[3] <= crc_reg[3] ^ crc_reg[2]; // Feedback from the polynomial
        crc_reg[2] <= crc_reg[2] ^ crc_reg[1];
        crc_reg[1] <= crc_reg[1] ^ crc_reg[0];
        crc_reg[0] <= crc_reg[0]; // No feedback for this bit
        crc_out <= crc_reg; // Output the CRC value
    end
    
    initial begin
        crc_reg = 4'b0000; // Initialize CRC register
    end
endmodule