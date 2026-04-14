module CSPRNG (
    input clk,
    input reset,
    input enable,
    output reg [7:0] random_number
);
    reg [7:0] lfsr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 8'b1; // Seed value
            random_number <= 8'b0;
        end else if (enable) begin
            // Linear Feedback Shift Register (LFSR) shift operation
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
            random_number <= lfsr;
        end
    end
endmodule