module flash_memory_cell (
    input wire clk,
    input wire write_enable,
    input wire data_in,
    output reg data_out
);
    reg stored_value;

    always @(posedge clk) begin
        if (write_enable) begin
            stored_value <= data_in;
        end
        data_out <= stored_value;
    end
endmodule