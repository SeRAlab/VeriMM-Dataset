module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q
);
    reg master;

    always @(posedge CLK) begin
        master <= D;  // Sample data on the rising edge of CLK
    end

    always @(negedge CLK) begin
        Q <= master;  // Update output on the falling edge of CLK
    end
endmodule