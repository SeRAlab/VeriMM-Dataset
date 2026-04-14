module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q
);
    reg Qm;  // Master latch output

    // Master latch
    always @(posedge CLK) begin
        Qm <= D;
    end

    // Slave latch
    always @(negedge CLK) begin
        Q <= Qm;
    end
endmodule