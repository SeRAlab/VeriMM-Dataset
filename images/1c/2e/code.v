module SRAM_Cell (
    input wire clk,
    input wire enable,
    input wire write_enable,
    input wire reset,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b00000000;
        end else if (write_enable) begin
            data_out <= data_in;
        end
    end

    always @(posedge clk) begin
        if (enable) begin
            // output data on enable
            data_out <= data_out;
        end
    end
endmodule