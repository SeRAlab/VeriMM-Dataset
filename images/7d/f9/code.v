module pulse_generator (
    input clk,
    input in_signal,
    output reg pulse_out
);

    reg in_signal_d;

    always @(posedge clk) begin
        in_signal_d <= in_signal;
        pulse_out <= in_signal & ~in_signal_d;
    end
endmodule