module dram_cell (
    input wire clk,
    input wire we,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    always @(posedge clk) begin
        if (we) begin
            data_out <= data_in; // Write data to the cell
        end
    end
endmodule