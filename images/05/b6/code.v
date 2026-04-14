module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q,
    output reg Qn
);

reg master;

always @(posedge CLK) begin
    master <= D; // Capture data on rising edge of clock
end

always @(negedge CLK) begin
    Q <= master; // Transfer data to output on falling edge of clock
    Qn <= ~Q;    // Complementary output
end

endmodule