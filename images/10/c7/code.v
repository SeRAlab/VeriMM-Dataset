module dram_cell (
    input wire D,       // Data input
    input wire WE,      // Write Enable
    output reg Q       // Data output
);
    always @ (posedge WE) begin
        Q <= D; // Store data on write enable
    end
endmodule