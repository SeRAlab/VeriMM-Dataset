module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q
);
    reg master;

    always @(posedge CLK) begin
        master <= D; // Capture input on rising edge
    end

    always @(negedge CLK) begin
        Q <= master; // Output follows master on falling edge
    end
endmodule