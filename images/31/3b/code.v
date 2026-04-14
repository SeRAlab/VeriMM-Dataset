module flash_memory_cell (
    input wire clk,
    input wire write_enable,
    input wire data_in,
    output reg data_out
);

always @(posedge clk) begin
    if (write_enable) begin
        data_out <= data_in; // Write new data on positive clock edge when enabled
    end
end

endmodule