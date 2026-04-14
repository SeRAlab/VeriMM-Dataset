module crc8_generator (
    input clk,
    input reset,
    input data_in,
    input data_valid,
    output reg [7:0] crc_out,
    output reg crc_valid
);
    reg [7:0] crc;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc <= 8'b0;
            crc_out <= 8'b0;
            crc_valid <= 0;
        end else if (data_valid) begin
            crc[0] <= crc[0] ^ data_in;
            crc[1] <= crc[1] ^ crc[0];
            crc[2] <= crc[2] ^ crc[1];
            crc[3] <= crc[3] ^ crc[2];
            crc[4] <= crc[4] ^ crc[3];
            crc[5] <= crc[5] ^ crc[4];
            crc[6] <= crc[6] ^ crc[5];
            crc[7] <= crc[7] ^ crc[6];

            // Polynomial division for CRC-8
            if (crc[7]) begin
                crc[7:0] <= {crc[6:0], 1'b0} ^ 8'h5D; // x^8 + x^7 + x^4 + x^3 + x^2 + 1
            end else begin
                crc <= {crc[6:0], 1'b0};
            end
        end
    end

    always @(posedge clk) begin
        if (data_valid) begin
            crc_valid <= 1;
        end else if (data_valid) begin
            crc_out <= crc;
        end
    end
endmodule