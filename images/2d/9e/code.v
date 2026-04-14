module flash_memory_cell (
    input wire clk,
    input wire data_in,
    input wire write_enable,
    input wire erase,
    output reg data_out
);
    
    always @(posedge clk) begin
        if (erase) begin
            data_out <= 1'b0; // Reset to 0 on erase
        end else if (write_enable) begin
            data_out <= data_in; // Write data input to memory
        end
    end

endmodule