module crc_generator (
    input [3:0] data_in,
    input clk,
    input rst,
    output reg [2:0] crc_out
);
    reg [6:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shift_reg <= 7'b0;
            crc_out <= 3'b0;
        end else begin
            shift_reg <= {shift_reg[5:0], data_in}; // Shift in data
            // CRC calculation based on polynomial x^3 + x + 1
            if (shift_reg[6]) begin
                shift_reg[6:3] = shift_reg[6:3] ^ 4'b1011; // x^3 + x + 1
            end
            crc_out <= shift_reg[2:0]; // Output last 3 bits as CRC
        end
    end
endmodule