module sram_cell (
    input [7:0] data_in,
    output reg [7:0] data_out,
    input write_enable,
    input read_enable,
    input clk
);
    reg [7:0] memory; // 8-bit memory register

    always @(posedge clk) begin
        if (write_enable) begin
            memory <= data_in; // Write data to memory
        end
    end

    always @(posedge clk) begin
        if (read_enable) begin
            data_out <= memory; // Read data from memory
        end
    end
endmodule