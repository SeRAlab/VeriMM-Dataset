module dram_cell (
    input wire [15:0] data_in,
    input wire write_enable,
    input wire [3:0] address,
    output reg [15:0] data_out
);
    
    reg [15:0] memory [0:15]; // 16 memory cells, each 16 bits
    
    always @(posedge write_enable) begin
        memory[address] <= data_in; // Write data to the selected address
    end
    
    always @(*) begin
        data_out = memory[address]; // Read data from the selected address
    end

endmodule