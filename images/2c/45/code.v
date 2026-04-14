module CSPRNG (
    input wire clk,
    input wire reset,
    input wire [3:0] seed,
    output reg [3:0] random_bits
);
    reg [3:0] lfsr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= seed; 
        end else begin
            lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};
        end
    end

    always @(posedge clk) begin
        random_bits <= lfsr;
    end
endmodule