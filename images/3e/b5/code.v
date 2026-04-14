module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q
);
    reg D_master;

    always @(posedge CLK) begin
        D_master <= D;  // Capture D when CLK is high
    end

    always @(negedge CLK) begin
        Q <= D_master;  // Output D_master when CLK goes low
    end
endmodule