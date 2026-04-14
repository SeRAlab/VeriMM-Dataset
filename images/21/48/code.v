module FlashMemoryCell (
    input wire write,
    input wire read,
    input wire data_in,
    output reg data_out
);
    always @(*) begin
        if (write) begin
            data_out = data_in; // Write data to memory
        end
        else if (read) begin
            // Output the stored value when read is high
            data_out = data_out; // Maintain the current value
        end
    end
endmodule