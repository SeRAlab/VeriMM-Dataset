module dram_cell (
    input clk,
    input write_en,
    input read_en,
    input [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory;

    always @(posedge clk) begin
        if (write_en) begin
            memory <= data_in; // Store data
        end
        if (read_en) begin
            data_out <= memory; // Output stored data
        end
    end
endmodule