module crc_generator (
    input wire clk,
    input wire reset,
    input wire [3:0] data_in,
    output reg [3:0] crc_out
);
    reg [3:0] lfsr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 4'b0000;
        end else begin
            lfsr[3] <= lfsr[2] ^ data_in[3];
            lfsr[2] <= lfsr[1];
            lfsr[1] <= lfsr[0];
            lfsr[0] <= lfsr[3] ^ data_in[3] ^ data_in[2];
        end
    end

    always @(posedge clk) begin
        crc_out <= lfsr;
    end
endmodule