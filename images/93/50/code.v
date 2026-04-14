module lfsr5(CLK, RST, LFSR_Out);
input CLK, RST;
output [4:0] LFSR_Out;
reg [4:0] LFSR_Out;

always @(posedge CLK or posedge RST) begin
    if (RST)
        LFSR_Out <= 5'b00001;
    else
        LFSR_Out <= {LFSR_Out[3] ^ LFSR_Out[1], LFSR_Out[4:1]};
end

endmodule