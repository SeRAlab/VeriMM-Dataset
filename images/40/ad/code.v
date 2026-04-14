module dram_cell (
    input clk,
    input we,
    input [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory;

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in;
        end
    end

    always @(negedge clk) begin
        data_out <= memory;
    end
endmodule