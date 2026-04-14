module flash_memory_cell(
    input wire clk,
    input wire write_enable,
    input wire data_in,
    output reg data_out
);

initial begin
    data_out = 1'b0; // Initialize to 0
end

always @(posedge clk) begin
    if (write_enable) begin
        data_out <= data_in; // Store the data on write enable
    end
end

endmodule