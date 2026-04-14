module master_slave_d_latch (
    input wire D,
    input wire clk,
    output reg Q
);
    reg Q_master;

    always @(posedge clk) begin
        Q_master <= D; // Capture D on rising edge
    end

    always @(negedge clk) begin
        Q <= Q_master; // Transfer to Q on falling edge
    end
endmodule