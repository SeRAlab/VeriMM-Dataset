module sram_cell(
    input [7:0] data_in,
    input write_enable,
    input clk,
    output reg [7:0] data_out
);
    
    always @(posedge clk) begin
        if (write_enable) begin
            data_out <= data_in;  // Store data on write enable
        end
    end

endmodule