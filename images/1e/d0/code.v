module flash_memory (
    input wire D,
    input wire WE,
    input wire RE,
    output reg Q
);
    always @(*) begin
        if (WE) begin
            Q <= D; // Write data to memory
        end else if (RE) begin
            // Output current value of Q (read operation)
            Q <= Q; 
        end
    end

    initial begin
        Q = 0; // Initialize memory cell to 0
    end
endmodule