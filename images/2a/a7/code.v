module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q
);
    reg master_latch;
    
    always @(posedge CLK) begin
        master_latch <= D;  // Master latch captures D on the positive edge of CLK
    end

    always @(negedge CLK) begin
        Q <= master_latch;  // Slave latch captures the output of master latch on the negative edge of CLK
    end
endmodule