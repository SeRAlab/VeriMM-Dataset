module crc_generator(
    input [3:0] data_in,
    input clk,
    input rst,
    output reg [3:0] crc_out 
);
    reg [3:0] crc_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            crc_reg <= 4'b0000;
            crc_out <= 4'b0000;
        end else begin
            crc_reg[3] <= crc_reg[2] ^ data_in[3]; // bit 3
            crc_reg[2] <= crc_reg[1] ^ data_in[2]; // bit 2
            crc_reg[1] <= crc_reg[0] ^ data_in[1]; // bit 1
            crc_reg[0] <= data_in[0];               // bit 0
            // Perform CRC polynomial division
            if (crc_reg[3]) begin
                crc_reg <= {crc_reg[2:0], 1'b0} ^ 4'b10101; // Shift and XOR with polynomial
            end else begin
                crc_reg <= {crc_reg[2:0], 1'b0}; // Just shift
            end
            crc_out <= crc_reg;
        end
    end
endmodule