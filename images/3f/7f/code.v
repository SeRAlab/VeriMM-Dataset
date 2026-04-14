module dram_cell (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory <= 8'b0;
            data_out <= 8'b0;
        end else if (enable) begin
            memory <= data_in;
            data_out <= memory;
        end else begin
            data_out <= memory;
        end
    end
endmodule