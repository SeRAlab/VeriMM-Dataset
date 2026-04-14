module phase_shifter (
    input [2:0] phase_in,
    output reg [2:0] phase_out
);
    
always @(*) begin
    phase_out = (phase_in + 3'b101) % 4; // 90 degrees = 3'b101 (5 in decimal)
end

endmodule