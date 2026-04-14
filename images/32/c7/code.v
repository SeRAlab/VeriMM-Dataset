module phase_shifter (
    input wire [2:0] phase_in,
    input wire control,
    output reg [2:0] phase_out
);

always @(phase_in or control) begin
    if (control) begin
        phase_out = {phase_in[1:0], phase_in[2]}; // Shift right
    end else begin
        phase_out = phase_in; // No shift
    end
end

endmodule