module flash_memory_cell (
    input wire data_in,
    input wire write_enable,
    input wire clk,
    output reg data_out
);
    
    always @(posedge clk) begin
        if (write_enable) begin
            data_out <= data_in;
        end
    end
    
endmodule