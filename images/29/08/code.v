module phase_detector (
    input wire clk,
    input wire signal_a,
    input wire signal_b,
    output reg [1:0] phase_out
);

always @(posedge clk) begin
    if (signal_a == signal_b) begin
        phase_out <= 2'b00; // in phase
    end else if (signal_a) begin
        phase_out <= 2'b01; // signal_a leading
    end else begin
        phase_out <= 2'b10; // signal_b leading
    end
end

endmodule