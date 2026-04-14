module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q
);

reg master;
reg slave;

// Master latch: capture D on the rising edge of CLK
always @(posedge CLK) begin
    master <= D;
end

// Slave latch: output master on the falling edge of CLK
always @(negedge CLK) begin
    slave <= master;
    Q <= slave;
end

endmodule