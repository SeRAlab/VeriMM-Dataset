module lfsr_csprng (
    input clk,
    input reset,
    input [4:0] seed,
    output reg [4:0] random_number
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            random_number <= seed;
        end else begin
            // LFSR feedback calculation
            random_number <= {random_number[3:0], random_number[4] ^ random_number[1] ^ random_number[0]};
        end
    end
endmodule