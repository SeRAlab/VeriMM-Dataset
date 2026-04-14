module CSPRNG (
    input wire clk,
    input wire rst,
    input wire [4:0] seed,
    output reg [4:0] random_out
);
    reg [4:0] lfsr;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr <= seed;
        end else begin
            // LFSR tap positions for a 5-bit LFSR
            lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[2] ^ lfsr[1]};
        end
    end

    always @(posedge clk) begin
        random_out <= lfsr;
    end
endmodule