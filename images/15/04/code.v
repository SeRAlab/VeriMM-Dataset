module crc_generator (
    input [15:0] data,
    input clk,
    output reg [15:0] crc
);
    reg [15:0] polynomial = 16'hA001; // Example polynomial for CRC
    integer i;

    always @(posedge clk) begin
        crc = data; // Initialize CRC with input data
        for (i = 0; i < 16; i = i + 1) begin
            if (crc[15] == 1) begin
                crc = (crc << 1) ^ polynomial; // Shift and XOR with polynomial
            end else begin
                crc = crc << 1; // Just shift
            end
        end
    end
endmodule