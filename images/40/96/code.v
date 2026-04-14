module master_slave_d_latch (
    input wire D,
    input wire EN,
    output reg Q
);
    reg Q_master;

    always @(posedge EN) begin
        Q_master <= D; // Master latch
    end

    always @(negedge EN) begin
        Q <= Q_master; // Slave latch
    end
endmodule