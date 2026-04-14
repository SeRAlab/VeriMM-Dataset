module crc32_generator(
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire data_valid,
    output reg [31:0] crc_out
);
    reg [31:0] crc;
    integer i;

    // CRC-32 polynomial: 0x04C11DB7
    localparam POLY = 32'h04C11DB7;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc <= 32'hFFFFFFFF; // Initial value
        end else if (data_valid) begin
            crc = crc ^ {data_in, 24'b0}; // XOR input data
            for (i = 0; i < 8; i = i + 1) begin
                if (crc[31]) begin
                    crc = (crc << 1) ^ POLY; // Shift and XOR with polynomial
                end else begin
                    crc = crc << 1; // Just shift
                end
            end
        end
    end

    always @(posedge clk) begin
        crc_out <= crc; // Output CRC value
    end
endmodule