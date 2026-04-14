module sram_cell (
    input wire [3:0] data_in,
    input wire enable,
    output reg [3:0] data_out,
    input wire clk
);

    reg [3:0] memory;

    always @(posedge clk) begin
        if (enable) begin
            memory <= data_in; // Write data to SRAM
        end
        data_out <= memory; // Output stored data
    end
endmodule