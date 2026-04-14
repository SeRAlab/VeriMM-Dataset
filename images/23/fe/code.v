module dram_cell (
    input wire clk,
    input wire we,      // write enable
    input wire data_in, // data input
    output reg data_out // data output
);
    
    always @(posedge clk) begin
        if (we) begin
            data_out <= data_in; // Store data on write enable
        end
    end
endmodule