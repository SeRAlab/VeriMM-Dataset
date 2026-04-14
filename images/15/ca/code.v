module flash_memory_cell (
    input wire write,
    input wire data,
    output reg q
);
    always @(*) begin
        if (write) begin
            q = data;
        end
        // Otherwise, retain the previous value of q
    end
endmodule