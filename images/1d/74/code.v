module flash_memory_cell (
    input clk,
    input write_enable,
    input [7:0] data_in,
    output reg [7:0] data_out,
    input reset
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b0;  // Clear the memory cell
        end else if (write_enable) begin
            data_out <= data_in;  // Write data to memory cell
        end
    end
endmodule