module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q
);

reg master_latch;

always @(posedge CLK) begin
    master_latch <= D; // Master latches D on the rising edge of the clock
end

always @(negedge CLK) begin
    Q <= master_latch; // Slave latches master on the falling edge of the clock
end

endmodule