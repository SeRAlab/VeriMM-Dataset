module dram_cell (
    input wire clk,
    input wire we, // write enable
    input wire [15:0] data_in, // data input
    output reg [15:0] data_out // data output
);
    reg [15:0] memory; // 16-bit memory cell

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Write data to memory
        end
    end

    always @(negedge clk) begin
        data_out <= memory; // Read data from memory
    end
endmodule