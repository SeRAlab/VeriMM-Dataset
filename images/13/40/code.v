module lfsr_8bit (
    input clk,
    input reset,
    input [7:0] seed,
    output reg [7:0] out
);
    reg [7:0] lfsr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= seed;
        end else begin
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
        end
    end

    always @(posedge clk) begin
        out <= lfsr;
    end
endmodule