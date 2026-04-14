module dram_cell (
    input wire [7:0] data_in,
    input wire we,
    input wire clk,
    output reg [7:0] data_out
);
    
    reg [7:0] memory;

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Write operation
        end
        data_out <= memory; // Read operation, always output the memory
    end

endmodule