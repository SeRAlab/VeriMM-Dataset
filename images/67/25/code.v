module top_module(
    input [63:0] data_in,
    input [7:0] poly,
    output reg [63:0] crc_out
);reg [63:0] crc_reg;
    integer i, j;
    
    always @(*) begin
        crc_reg = 64'hFFFFFFFFFFFFFFFF;
        for (i = 0; i < 64; i = i + 8) begin  // Corrected $size(data_in) to 64
            crc_reg = crc_reg << 8;
            crc_reg[63:56] = crc_reg[63:56] ^ data_in[i +: 8]; // Changed to use '+:' for a part-select
            for (j = 7; j >= 0; j = j - 1) begin
                if (crc_reg[63] == 1) begin
                    crc_reg = crc_reg ^ (poly << j);
                end
                crc_reg = crc_reg << 1;
            end
        end
        crc_out = crc_reg;
    end
    
endmodule