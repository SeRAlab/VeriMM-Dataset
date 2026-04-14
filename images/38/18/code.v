module crc_generator (
    input clk,
    input rst,
    input [7:0] data_in,
    input valid,
    output reg [3:0] crc_out
);

    reg [3:0] lfsr;
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr <= 4'b0000; // Reset LFSR
            crc_out <= 4'b0000; // Reset CRC output
        end else if (valid) begin
            lfsr <= lfsr ^ (data_in[0] ? 4'b1001 : 4'b0000);
            for (i = 1; i < 8; i = i + 1) begin
                lfsr <= {lfsr[2:0], 1'b0} ^ (lfsr[3] ? 4'b1001 : 4'b0000);
                lfsr[3] <= lfsr[3] ^ data_in[i];
            end
            crc_out <= lfsr;
        end
    end

endmodule