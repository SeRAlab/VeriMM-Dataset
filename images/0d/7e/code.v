module flash_memory_cell (
    input data,
    input write_enable,
    output reg stored_data
);
    always @(*) begin
        if (write_enable) begin
            stored_data = data;
        end
    end
endmodule