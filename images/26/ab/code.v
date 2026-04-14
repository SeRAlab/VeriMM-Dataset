module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q
);
    reg master;
    
    always @(posedge CLK) begin
        master <= D; // Master captures the input data when CLK is high
    end
    
    always @(negedge CLK) begin
        Q <= master; // Slave outputs the captured data when CLK goes low
    end
endmodule