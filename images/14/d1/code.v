module dram_cell (
    input wire clk,
    input wire we, // Write enable
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Store input data
        end
    end

    always @(*) begin
        data_out = memory; // Output current memory value
    end
endmodule