module sram_cell (
    input wire D,        // Data input
    input wire WE,       // Write Enable
    input wire RE,       // Read Enable
    output reg Q         // Data output
);
    reg memory;          // Internal memory storage

    always @(posedge WE) begin
        memory <= D;     // Write data to memory on WE
    end

    always @(posedge RE) begin
        Q <= memory;     // Read data from memory on RE
    end
endmodule