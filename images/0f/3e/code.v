module master_slave_d_latch (
    input wire D,
    input wire clk,
    output reg Q
);
    reg master;
    reg slave;

    always @(posedge clk) begin
        master <= D; // Capture D on the rising edge of clk
    end

    always @(negedge clk) begin
        slave <= master; // Transfer master output to slave on the falling edge of clk
        Q <= slave; // Update Q
    end
endmodule