module crc32_generator(
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [31:0] data_in,
    output reg [31:0] crc_out
);
    reg [31:0] crc;
    parameter POLYNOMIAL = 32'h04C11DB7; // Example polynomial

    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc <= 32'b0;
        end else if (enable) begin
            crc = crc ^ data_in; // Initial XOR with input data
            for (i = 0; i < 32; i = i + 1) begin
                if (crc[31] == 1'b1) begin
                    crc = (crc << 1) ^ POLYNOMIAL;
                end else begin
                    crc = crc << 1;
                end
            end
        end
    end

    always @(posedge clk) begin
        if (enable) begin
            crc_out <= crc;
        end
    end
endmodule