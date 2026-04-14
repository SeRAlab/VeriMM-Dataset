module dram_cell (
    input wire D,       // Data input
    input wire WE,      // Write Enable
    input wire RE,      // Read Enable
    output reg Q        // Data output
);
    reg stored_data;    // Internal storage

    always @(posedge WE) begin
        stored_data <= D; // Write data to cell
    end

    always @(posedge RE) begin
        Q <= stored_data; // Read data from cell
    end
endmodule