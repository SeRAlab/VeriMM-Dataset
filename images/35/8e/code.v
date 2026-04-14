module dram_cell (
    input wire data_in,
    input wire we,
    input wire clk,
    output reg data_out
);
    always @(posedge clk) begin
        if (we) begin
            data_out <= data_in; // write data to the cell
        end
        // else do nothing, data_out retains its value
    end
endmodule