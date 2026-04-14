module dram_cell (
    input wire [15:0] data_in,
    output reg [15:0] data_out,
    input wire wr_en,
    input wire clk,
    input wire reset
);

    reg [15:0] memory;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory <= 16'b0;
            data_out <= 16'b0;
        end else if (wr_en) begin
            memory <= data_in;
        end
    end

    always @(posedge clk) begin
        data_out <= memory;
    end

endmodule