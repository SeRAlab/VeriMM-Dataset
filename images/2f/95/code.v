module phase_shifter (
    input wire [2:0] phase_in,
    input wire control,
    output reg [2:0] phase_out
);
    always @(*) begin
        if (control == 0) begin
            // Shift left
            phase_out = {phase_in[1:0], phase_in[2]};
        end else begin
            // Shift right
            phase_out = {phase_in[0], phase_in[2:1]};
        end
    end
endmodule