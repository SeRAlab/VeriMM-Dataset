module dram_cell (
    input wire d,        // Data input
    input wire we,      // Write enable
    input wire re,      // Read enable
    input wire clk,     // Clock signal
    output reg q        // Data output
);
    reg stored_data;    // Internal storage for the DRAM cell

    always @(posedge clk) begin
        if (we) begin
            stored_data <= d; // Store data on the rising edge of clk when we is high
        end
    end

    always @(posedge clk) begin
        if (re) begin
            q <= stored_data; // Output stored data on the rising edge of clk when re is high
        end
    end
endmodule