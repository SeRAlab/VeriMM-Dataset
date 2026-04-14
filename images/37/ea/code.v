module csprng(
    input wire clk,
    input wire reset,
    input wire [3:0] seed,
    output reg [3:0] random_number
);

reg [3:0] lfsr;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        lfsr <= seed;
        random_number <= seed;
    end else begin
        lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[1]}; // Polynomial x^4 + x + 1
        random_number <= lfsr;
    end
end

endmodule