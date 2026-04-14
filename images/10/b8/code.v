module flash_memory (
    input wire write,
    input wire data_in,
    output reg data_out
);
    always @(*) begin
        if (write) begin
            data_out = data_in; // Write the input data to the memory cell
        end
        // If write is low, retain the current value of data_out
    end
endmodule