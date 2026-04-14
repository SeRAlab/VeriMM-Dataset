module crc32_generator(
    input [31:0] data_in,
    input valid,
    output reg [31:0] crc_out
);
    reg [31:0] crc;
    integer i;

    always @(*) begin
        if (valid) begin
            crc = 32'hFFFFFFFF; // Initial value
            for (i = 0; i < 32; i = i + 1) begin
                crc = crc ^ data_in[i];
                if (crc[31]) begin
                    crc = {crc[30:0], 1'b0} ^ 32'h04C11DB7; // CRC polynomial
                end else begin
                    crc = {crc[30:0], 1'b0};
                end
            end
            crc_out = ~crc; // Final XOR
        end else begin
            crc_out = 32'b0; // Output zero if not valid
        end
    end
endmodule