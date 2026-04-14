module flash_memory (
    input wire write_data,
    input wire control,
    output reg read_data
);
    reg memory_cell;

    always @(*) begin
        if (control) begin
            read_data = memory_cell; // read from memory
        end else begin
            memory_cell = write_data; // write to memory
        end
    end
endmodule