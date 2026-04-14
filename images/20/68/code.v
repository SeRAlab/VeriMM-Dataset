module dram_cell (
    input wire clk,
    input wire [2:0] addr,
    input wire we, // write enable
    input wire re, // read enable
    input wire [7:0] data_in,
    output reg [7:0] data_out
);

    reg [7:0] memory [0:7]; // 8 DRAM cells

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write data to the specified address
        end
    end

    always @(posedge clk) begin
        if (re) begin
            data_out <= memory[addr]; // Read data from the specified address
        end
    end

endmodule