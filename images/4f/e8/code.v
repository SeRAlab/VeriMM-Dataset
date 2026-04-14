module lfsr(
    input clk,
    input reset,
    input enable,
    output reg [7:0] lfsr_out
    );

    wire feedback = lfsr_out[7] ^ lfsr_out[5] ^ lfsr_out[4] ^ lfsr_out[3];

    always @(posedge clk or posedge reset) begin
        if (reset)
            lfsr_out <= 8'b00000001;
        else if (enable)
            lfsr_out <= {lfsr_out[6:0], feedback};
    end
endmodule