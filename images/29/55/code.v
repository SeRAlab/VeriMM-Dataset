module crc_generator (
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    output reg [2:0] crc_out
);
    reg [7:0] crc;
    wire [7:0] polynomial = 8'b1011;  // x^3 + x + 1

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            crc <= 8'b0;
            crc_out <= 3'b0;
        end else begin
            crc <= data_in ^ (crc << 1); // Shift and XOR
            if (crc[7]) begin
                crc <= crc ^ polynomial; // If the highest bit is set, XOR with polynomial
            end
            crc_out <= crc[2:0]; // Take the last 3 bits as CRC output
        end
    end
endmodule