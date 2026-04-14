module flash_memory_cell (
    input wire D,
    input wire WE,
    output reg Q
);
    always @(*) begin
        if (WE) begin
            Q = D; // Write operation
        end
        // If WE is low, keep the previous value of Q
    end
endmodule