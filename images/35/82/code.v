module dram_cell (
    input wire clk,
    input wire control, // 1 for write, 0 for read
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (control) begin
            memory <= data_in; // Write data
        end
        else begin
            data_out <= memory; // Read data
        end
    end
endmodule