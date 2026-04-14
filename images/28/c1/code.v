module flash_memory (
    input wire data_in,
    input wire write_enable,
    output reg data_out
);
    always @(*) begin
        if (write_enable) begin
            data_out = data_in; // Store the input value
        end
        // If not writing, retain the last value
    end
endmodule