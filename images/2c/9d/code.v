module phase_shifter (
    input [2:0] phase_in,
    output reg [2:0] phase_out
);

always @(*) begin
    phase_out = (phase_in + 3'b001) % 3'b1000; // Shift phase by 1 degree modulo 8
end

endmodule