module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q
);
    reg master;
    
    always @(posedge CLK) begin
        master <= D; // Capture D when CLK rises
    end
    
    always @(negedge CLK) begin
        Q <= master; // Update Q on falling edge of CLK
    end
endmodule