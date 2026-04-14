module dram_cell (
    input wire clk,
    input wire enable,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);
    always @(posedge clk) begin
        if (enable) begin
            data_out <= data_in; // Write data
        end
    end
endmodule