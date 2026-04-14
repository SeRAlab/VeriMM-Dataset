module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q,
    output reg Qn
);
    reg master;
    reg slave;

    always @(posedge CLK) begin
        master <= D; // Master latch is transparent on the rising edge of CLK
    end

    always @(negedge CLK) begin
        slave <= master; // Slave latch captures the master's value on the falling edge of CLK
        Q <= slave;
        Qn <= ~slave;
    end
endmodule