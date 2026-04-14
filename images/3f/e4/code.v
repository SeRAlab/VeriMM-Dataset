module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q,
    output reg Qn
);

reg master;

always @(posedge CLK) begin
    master <= D;   // Master latch captures D on rising edge of CLK
end

always @(negedge CLK) begin
    Q <= master;   // Slave latch captures master on falling edge of CLK
    Qn <= ~Q;      // Inverted output
end

endmodule