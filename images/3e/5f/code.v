module master_slave_d_latch (
    input wire D,
    input wire CLK,
    output reg Q
);
    reg master;

    always @(posedge CLK) begin
        master <= D; // Capture D in Master on CLK rising edge
    end

    always @(negedge CLK) begin
        Q <= master; // Update Q from Master on CLK falling edge
    end
endmodule