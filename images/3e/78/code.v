module flash_memory_cell (
    input wire clk,
    input wire reset,
    input wire write_enable,
    input wire erase_enable,
    input wire data_in,
    output reg data_out
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 1'b0;  // Initialize to 0 on reset
        end else if (erase_enable) begin
            data_out <= 1'b0;  // Erase sets to 0
        end else if (write_enable) begin
            data_out <= data_in;  // Write new data
        end
    end
endmodule