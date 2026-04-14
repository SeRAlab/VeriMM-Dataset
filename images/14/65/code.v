module master_slave_d_latch (
    input wire D,
    input wire clk,
    output reg Q
);
    reg master, slave;

    always @(posedge clk) begin
        master <= D; // Capture D on the rising edge of clk
    end

    always @(negedge clk) begin
        slave <= master; // Output the master value on the falling edge of clk
    end

    always @(negedge clk) begin
        Q <= slave; // Update Q
    end
endmodule