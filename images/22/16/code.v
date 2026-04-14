module crc8 (
    input clk,
    input reset,
    input [7:0] data_in,
    input start,
    output reg [7:0] crc_out,
    output reg done
);
    reg [7:0] crc;
    integer i;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc <= 8'h00;
            done <= 1'b0;
        end else if (start) begin
            crc <= 8'h00; // Reset CRC
            for (i = 0; i < 8; i = i + 1) begin
                crc[7] <= crc[6] ^ data_in[i];
                crc[6] <= crc[5];
                crc[5] <= crc[4];
                crc[4] <= crc[3];
                crc[3] <= crc[2];
                crc[2] <= crc[1];
                crc[1] <= crc[0];
                crc[0] <= (crc[7] ^ (data_in[i] ? 1'b1 : 1'b0));
                if (crc[7]) begin
                    crc[7:0] = (crc[7:0] ^ 8'h31);
                end
            end
            crc_out <= crc;
            done <= 1'b1;
        end
    end
endmodule