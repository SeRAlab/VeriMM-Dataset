module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q
);
    reg master_latch;
    
    always @(posedge CLK) begin
        master_latch <= D; // Capture D value when CLK is high
    end
    
    always @(negedge CLK) begin
        Q <= master_latch; // Output the captured value when CLK goes low
    end
endmodule