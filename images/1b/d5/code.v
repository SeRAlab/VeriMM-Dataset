module master_slave_d_latch(
    input wire D,
    input wire E,
    output reg Q,
    output reg Q_not
);
    reg master;

    always @(posedge E) begin
        master <= D; // Master latch captures D on the rising edge of E
    end

    always @(negedge E) begin
        Q <= master; // Slave latch captures master on the falling edge of E
    end

    always @(*) begin
        Q_not = ~Q; // Q_not is the inverse of Q
    end
endmodule