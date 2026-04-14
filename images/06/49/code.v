module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q
);

reg Q_master;

always @(posedge CLK) begin
    Q_master <= D; // Sample D on the rising edge of CLK
end

always @(negedge CLK) begin
    Q <= Q_master; // Transfer to Q on the falling edge of CLK
end

endmodule