module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q
);
    reg master;

    always @(posedge CLK) begin
        master <= D; // Capture D when CLK is high
    end

    always @(negedge CLK) begin
        Q <= master; // Transfer master to Q when CLK goes low
    end
endmodule