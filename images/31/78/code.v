module dram_cell (
    input wire [3:0] data_in,
    input wire we,
    input wire clk,
    output reg [3:0] data_out
);

always @(posedge clk) begin
    if (we) begin
        data_out <= data_in; // Write data
    end
end

endmodule