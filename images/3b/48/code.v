module dram_cell (
    input wire d,      // Data input
    input wire we,     // Write enable
    output reg q       // Data output
);
    
    always @(posedge we) begin
        if (we) begin
            q <= d;    // Store data when we is high
        end
    end

endmodule