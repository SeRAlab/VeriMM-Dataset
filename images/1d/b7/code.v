module dram_cell (
    input wire clk,
    input wire we, // write enable
    input wire [15:0] data_in, // data input
    output reg [15:0] data_out // data output
);
    always @(posedge clk) begin
        if (we) begin
            data_out <= data_in; // write data to the cell
        end
    end
endmodule