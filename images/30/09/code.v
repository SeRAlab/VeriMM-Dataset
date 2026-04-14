module CSPRNG (
    input clk,
    input reset,
    input [7:0] seed,
    output reg random_bit
);
    reg [7:0] lfsr;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= seed;
        end else begin
            random_bit <= lfsr[0]; // output the least significant bit
            // LFSR feedback polynomial: x^8 + x^6 + x^5 + x^4 + 1
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[0]};
        end
    end
endmodule