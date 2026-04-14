module master_slave_d_latch (
    input wire D,
    input wire E,
    output reg Q,
    output wire Q_n
);
    assign Q_n = ~Q;

    reg master;
    always @(D or E) begin
        if (E) begin
            master <= D; // Master latch
        end
    end

    always @(posedge E) begin
        Q <= master; // Slave latch
    end
endmodule