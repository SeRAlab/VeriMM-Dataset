module crc_generator (
    input wire clk,
    input wire rst,
    input wire [3:0] data_in,
    output reg [3:0] crc_out
);
    reg [3:0] lfsr;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr <= 4'b0001; // Initialize LFSR with a non-zero value
            crc_out <= 4'b0000;
        end else begin
            lfsr[3] <= lfsr[2];
            lfsr[2] <= lfsr[1] ^ data_in[3];
            lfsr[1] <= lfsr[0] ^ data_in[2];
            lfsr[0] <= data_in[1];
            crc_out <= lfsr;
        end
    end
endmodule