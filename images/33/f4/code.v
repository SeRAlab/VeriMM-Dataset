module CSPRNG(
    input wire clk,
    input wire rst,
    input wire [4:0] seed,
    output reg [4:0] random_number
);
    reg [4:0] lfsr;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr <= seed;
        end else begin
            lfsr <= {lfsr[3:0], lfsr[4] ^ lfsr[3] ^ lfsr[1] ^ lfsr[0]};
            random_number <= lfsr;
        end
    end
endmodule