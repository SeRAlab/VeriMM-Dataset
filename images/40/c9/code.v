module phase_shifter (
    input [2:0] phase_in,
    output reg [2:0] phase_out
);

always @(*) begin
    case (phase_in)
        3'd0: phase_out = 3'd1;
        3'd1: phase_out = 3'd2;
        3'd2: phase_out = 3'd3;
        3'd3: phase_out = 3'd4;
        3'd4: phase_out = 3'd5;
        3'd5: phase_out = 3'd6;
        3'd6: phase_out = 3'd7;
        3'd7: phase_out = 3'd0;
        default: phase_out = 3'd0; // default case
    endcase
end

endmodule