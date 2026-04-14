module CSPRNG (
    input clk,
    input rst,
    input [3:0] seed,
    output reg [3:0] random_num
);
    reg [3:0] lfsr;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr <= seed;
            random_num <= seed;
        end else begin
            lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};  // LFSR feedback
            random_num <= lfsr;
        end
    end
endmodule