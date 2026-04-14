module master_slave_d_latch (
    input wire D,         // Data input
    input wire clk,      // Clock (enable) input
    output reg Q         // Output
);
    reg master;          // Master latch output

    always @(clk or D) begin
        if (clk) begin
            master <= D; // Capture data on enable high
        end
    end

    always @(negedge clk) begin
        Q <= master;     // Output the master value on enable low
    end
endmodule