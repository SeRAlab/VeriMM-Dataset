module master_slave_d_latch (
    input D,
    input CLK,
    output reg Q
);
    reg master;

    always @(posedge CLK) begin
        master <= D;  // Capture D on the rising edge of the clock
    end

    always @(negedge CLK) begin
        Q <= master;  // Output the master value on the falling edge of the clock
    end
endmodule