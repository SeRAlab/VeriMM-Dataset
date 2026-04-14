module crc32_generator (
    input clk,
    input rst_n,
    input [31:0] data_in,
    input data_valid,
    output reg [31:0] crc_out
);
    reg [31:0] crc;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            crc <= 32'hFFFFFFFF; // Initial CRC value
        end else if (data_valid) begin
            // CRC computation logic (example using polynomial)
            crc <= (crc >> 1) ^ (data_in[0] ? 32'hEDB88320 : 32'h00000000); // Simple example
        end
    end

    always @(posedge clk) begin
        crc_out <= crc;
    end
endmodule