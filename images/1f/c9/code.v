module SRAM_Cell (
    input wire D,        // Data input
    input wire WE,      // Write enable
    input wire RE,      // Read enable
    output reg Q        // Data output
);
    reg stored_data;

    always @(posedge WE) begin
        stored_data <= D; // Write data to the cell
    end

    always @(posedge RE) begin
        Q <= stored_data; // Output the stored data
    end
endmodule