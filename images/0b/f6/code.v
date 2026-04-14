module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q
);
    reg master;
    
    always @(posedge CLK) begin
        master <= D;  // Capture data on rising edge of CLK
    end
    
    always @(negedge CLK) begin
        Q <= master;  // Output the captured data on falling edge of CLK
    end
endmodule