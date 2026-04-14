module dram_cell (
    input wire clk,
    input wire enable,
    input wire write,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge clk) begin
        if (enable) begin
            if (write) begin
                memory <= data_in;
            end else begin
                data_out <= memory;
            end
        end
    end
endmodule