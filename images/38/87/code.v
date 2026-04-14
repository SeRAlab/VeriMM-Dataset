module dram_cell (
    input wire clk,
    input wire we,      // Write enable
    input wire [7:0] data_in, // Data input
    output reg [7:0] data_out // Data output
);
    
    reg [7:0] memory; // 8-bit storage
    
    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Write data to memory
        end
        data_out <= memory; // Always output the stored data
    end
endmodule