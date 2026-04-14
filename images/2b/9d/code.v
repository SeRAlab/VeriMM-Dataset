module sram_cell (
    input wire D,       // Data input
    input wire WE,      // Write enable
    input wire RE,      // Read enable
    output reg Q        // Data output
);
    reg stored_data;    // Internal storage for data

    always @ (posedge WE) begin
        stored_data <= D; // Store data on write enable
    end

    always @ (posedge RE) begin
        Q <= stored_data; // Output stored data on read enable
    end
endmodule