module phase_shifter(
    input [4:0] phase_in,
    input [4:0] shift_amount,
    output reg [4:0] phase_out
);
    always @(*) begin
        phase_out = (phase_in + shift_amount) % 32; // Wrap around at 32
    end
endmodule