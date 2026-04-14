module dram_cell (
    input wire d_in,
    input wire we,
    input wire re,
    output reg d_out
);
    reg storage; // Internal storage for 1-bit data

    always @(posedge we) begin
        if (we) begin
            storage <= d_in; // Store data on write enable
        end
    end
    
    always @(posedge re) begin
        if (re) begin
            d_out <= storage; // Output data on read enable
        end
    end
endmodule