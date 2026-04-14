module dram_cell (
    input wire clk,
    input wire [15:0] data_in,
    input wire write_en,
    input wire read_en,
    output reg [15:0] data_out
);
    reg [15:0] memory;

    always @(posedge clk) begin
        if (write_en) begin
            memory <= data_in; // Store input data in memory
        end
    end

    always @(posedge clk) begin
        if (read_en) begin
            data_out <= memory; // Output stored data
        end
    end
endmodule