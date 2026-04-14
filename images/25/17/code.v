module SRAM_1bit (
    input wire clk,
    input wire we,        // Write enable
    input wire re,        // Read enable
    input wire d,        // Data input
    output reg q         // Data output
);
    reg stored_data;

    always @(posedge clk) begin
        if (we) begin
            stored_data <= d; // Write data to the cell
        end
    end

    always @(posedge clk) begin
        if (re) begin
            q <= stored_data; // Read data from the cell
        end
    end
endmodule