module dram_cell (
    input wire clk,
    input wire we,
    input wire data,
    output reg q
);
    always @(posedge clk) begin
        if (we) begin
            q <= data;
        end
    end
endmodule