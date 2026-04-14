module dram_cell (
    input wire D,        // Data input
    input wire WE,       // Write Enable
    input wire clk,      // Clock signal
    output reg Q         // Data output
);

    always @(posedge clk) begin
        if (WE) begin
            Q <= D;      // Write data when WE is high
        end
        // Q retains its value when WE is low
    end

endmodule