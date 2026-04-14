module lfsr_5bit(
    input clk,
    input reset_n,
    output reg [4:0] lfsr_out
);
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            lfsr_out <= 5'b00001;
        else
            lfsr_out <= {lfsr_out[3:0], lfsr_out[4] ^ lfsr_out[2]};
    end
endmodule