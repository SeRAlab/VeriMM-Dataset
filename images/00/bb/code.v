module dram_cell (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire write_enable,
    input wire read_enable,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            memory <= 8'b0;
            data_out <= 8'b0;
        end else begin
            if (write_enable) begin
                memory <= data_in;
            end
            if (read_enable) begin
                data_out <= memory;
            end
        end
    end
endmodule