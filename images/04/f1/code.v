module phase_shifter (
    input [2:0] signal_in,
    input [1:0] control,
    output reg [2:0] signal_out
);
    always @(*) begin
        case (control)
            2'b00: signal_out = signal_in;          // 0 degrees shift
            2'b01: signal_out = {signal_in[1:0], signal_in[2]}; // 90 degrees shift
            2'b10: signal_out = {signal_in[2], signal_in[1:0]}; // 180 degrees shift
            2'b11: signal_out = {signal_in[0], signal_in[2:1]}; // 270 degrees shift
            default: signal_out = signal_in;        // default case
        endcase
    end
endmodule