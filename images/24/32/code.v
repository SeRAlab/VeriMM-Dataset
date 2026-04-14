module dram_cell (
    input wire [7:0] data_in,
    input wire write_enable,
    input wire clk,
    output reg [7:0] data_out
);
    always @(posedge clk) begin
        if (write_enable) begin
            data_out <= data_in;
        end
    end
endmodule