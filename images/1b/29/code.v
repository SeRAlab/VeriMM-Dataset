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
            crc_out <= 4'b0000;
        end else begin
            lfsr <= {lfsr[2:0], data_in[0] ^ lfsr[3]};
            crc_out <= lfsr;
        end
    end
endmodule