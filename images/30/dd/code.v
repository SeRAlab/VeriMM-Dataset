module sram_cell (
    input  [7:0] data_in,
    input        rw,
    input        ce,
    input  [2:0] addr,
    output reg [7:0] data_out
);
    
    reg [7:0] memory [0:7]; // 8-bit SRAM, 8 locations

    always @(posedge rw or negedge ce) begin
        if (!ce) begin
            // Chip is disabled, ignore operations
            data_out <= 8'bz; // High-Z state
        end else if (rw) begin
            // Write operation
            memory[addr] <= data_in;
        end else begin
            // Read operation
            data_out <= memory[addr];
        end
    end
endmodule