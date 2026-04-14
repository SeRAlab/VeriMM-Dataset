module lfsr_7bit (
    input clk,
    input en,
    input rst,
    output reg [6:0] lfsr_out
);

    wire feedback = lfsr_out[6] ^ lfsr_out[5];

    always @(posedge clk) begin
        if (rst)
            lfsr_out <= 7'b0000001;  // Non-zero seed
        else if (en)
            lfsr_out <= {lfsr_out[5:0], feedback};
    end
endmodule