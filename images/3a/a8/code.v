module dram_cell (
    input clk,
    input [3:0] data_in,
    input write_enable,
    input read_enable,
    output reg [3:0] data_out
);
    reg [3:0] memory; // 4-bit memory storage

    always @(posedge clk) begin
        if (write_enable) begin
            memory <= data_in; // Store data
        end
        if (read_enable) begin
            data_out <= memory; // Output stored data
        end
    end
endmodule