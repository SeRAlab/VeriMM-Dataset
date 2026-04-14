module spi_controller (
    input clk,
    input start,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    always @(posedge clk) begin
        if (start) begin
            data_out <= data_in; // latch the input data
        end
    end
endmodule