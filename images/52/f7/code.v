module lfsr(CLK, RST, LFSR_OUT);
input CLK, RST;
output [4:0] LFSR_OUT;
reg [4:0] LFSR_OUT;

always @(posedge CLK or posedge RST) begin
    if (RST)
        LFSR_OUT <= 5'b00001; // Non-zero initial value
    else begin
        LFSR_OUT <= {LFSR_OUT[3:0], LFSR_OUT[4] ^ LFSR_OUT[2]};
    end
end

endmodule