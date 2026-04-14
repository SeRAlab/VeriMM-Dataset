module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q
);
    reg Q_master;

    always @ (posedge CLK) begin
        Q_master <= D;  // Capture D when CLK is high
    end

    always @ (negedge CLK) begin
        Q <= Q_master;  // Transfer Q_master to Q when CLK goes low
    end
endmodule