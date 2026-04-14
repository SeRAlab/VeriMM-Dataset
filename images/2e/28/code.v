module dram_cell (
    input wire [7:0] data_in,
    input wire we, // write enable
    input wire clk,
    output reg [7:0] data_out
);
    
    reg [7:0] memory; // 8-bit memory cell
    
    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Write data to memory
        end
    end
    
    always @* begin
        data_out = memory; // Output the stored data
    end
endmodule