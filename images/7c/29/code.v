module lfsr(
    input clk,
    input reset,
    output reg [4:0] lfsr_out
    );
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            lfsr_out <= 5'b11111;
        else
            lfsr_out <= {lfsr_out[3:0], lfsr_out[4] ^ lfsr_out[2]};
    end
endmodule