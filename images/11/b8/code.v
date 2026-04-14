module lfsr_csprng (
    input clk,
    input reset,
    output reg [2:0] random_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            random_out <= 3'b001; // Initial seed
        end else begin
            random_out <= {random_out[1:0], random_out[2] ^ random_out[1]};
        end
    end
endmodule