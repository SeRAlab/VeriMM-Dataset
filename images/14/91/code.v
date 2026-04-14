module crc32_generator (
    input wire clk,
    input wire reset,
    input wire [31:0] data_in,
    output reg [31:0] crc_out
);
    reg [31:0] crc_reg;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc_reg <= 32'hFFFFFFFF; // Initial value for CRC-32
        end else begin
            crc_reg <= crc_reg ^ data_in; // Initialize CRC with incoming data
            for (i = 0; i < 32; i = i + 1) begin
                if (crc_reg[31] == 1'b1) begin
                    crc_reg = (crc_reg << 1) ^ 32'h04C11DB7; // CRC-32 polynomial
                end else begin
                    crc_reg = crc_reg << 1;
                end
            end
        end
    end

    always @(posedge clk) begin
        crc_out <= crc_reg;
    end
endmodule