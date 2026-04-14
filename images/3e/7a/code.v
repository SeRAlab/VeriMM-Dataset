module flash_memory_cell (
    input wire D,
    input wire C,
    output reg Q
);
    always @(*) begin
        if (C) begin
            Q = D; // Update output with input when control is high
        end
        // If control is low, retain previous state: no change to Q
    end
endmodule