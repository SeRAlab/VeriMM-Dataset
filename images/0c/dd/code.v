module dram_cell (
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    input wire write_en,
    input wire read_en,
    input wire reset,
    input wire clk
);
    reg [7:0] memory;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory <= 8'b00000000;
        end else if (write_en) begin
            memory <= data_in;
        end
    end

    always @(posedge clk) begin
        if (read_en) begin
            data_out <= memory;
        end
    end
endmodule