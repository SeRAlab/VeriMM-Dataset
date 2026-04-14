module phase_detector (
    input wire signal_a,
    input wire signal_b,
    output reg [1:0] phase_out
);

always @(signal_a or signal_b) begin
    if (signal_a == signal_b) begin
        phase_out = 2'b00; // Equal
    end else if (signal_a > signal_b) begin
        phase_out = 2'b01; // signal_a leading
    end else begin
        phase_out = 2'b10; // signal_a lagging
    end
end

endmodule