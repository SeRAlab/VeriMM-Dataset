module lfsr_csprng (
    input wire clk,
    input wire reset,
    input wire [2:0] seed,
    output reg [2:0] random_out
);

    reg [2:0] lfsr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= seed;
            random_out <= seed;
        end else begin
            lfsr <= {lfsr[1:0], lfsr[2] ^ lfsr[0]}; // Feedback polynomial: x^3 + x + 1
            random_out <= lfsr;
        end
    end
endmodule