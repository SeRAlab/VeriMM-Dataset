module flash_memory_cell (
    input clk,
    input write_enable,
    input read_enable,
    input data_in,
    output reg data_out
);
    reg stored_data;

    always @(posedge clk) begin
        if (write_enable) begin
            stored_data <= data_in;
        end
    end

    always @(posedge clk) begin
        if (read_enable) begin
            data_out <= stored_data;
        end
    end
endmodule