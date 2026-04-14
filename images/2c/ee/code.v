module flash_memory_cell (
    input wire clk,
    input wire write,
    input wire read,
    input wire d,
    output reg q
);
    
    always @(posedge clk) begin
        if (write) begin
            q <= d; // Store the input data when write is high
        end
    end
    
    always @(posedge clk) begin
        if (read) begin
            // If read is high, output the stored value (no change in q here)
            // This is effectively done as q is updated on write only
        end
    end
    
endmodule