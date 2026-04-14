module accepts(input [3:0] In, input Clock, output reg Out);

reg [14:0] LFSR;

always @(posedge Clock) begin
    LFSR[0] <= LFSR[13] ^ LFSR[14];
    LFSR[14:1] <= LFSR[13:0];
    if(LFSR==15'b001000010001100) Out <= 1;
end

endmodule