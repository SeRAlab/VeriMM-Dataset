module prng_lfsr (
    input clk,
    input reset,
    output reg [6:0] prng
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            prng <= 7'b0000001; // Non-zero seed
        end else begin
            prng <= {prng[5:0], prng[6] ^ prng[5]};
        end
    end

endmodule