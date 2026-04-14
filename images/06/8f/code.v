module dram_cell (
    input wire [2:0] address,
    input wire data_in,
    input wire we,
    input wire re,
    output reg data_out
);
    reg [7:0] memory; // 8-bit memory array

    // Write process
    always @(posedge we) begin
        memory[address] <= data_in;
    end

    // Read process
    always @(posedge re) begin
        data_out <= memory[address];
    end
endmodule