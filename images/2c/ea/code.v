module dram_cell (
    input wire clk,
    input wire wr_en,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    always @(posedge clk) begin
        if (wr_en) begin
            data_out <= data_in;
        end
    end
endmodule