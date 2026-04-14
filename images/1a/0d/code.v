module FlashMemoryCell (
    input wire D,
    input wire WE,
    input wire RE,
    output reg Q
);
    // Internal temporary storage
    always @(posedge WE or posedge RE) begin
        if (WE) begin
            Q <= D; // Write data to the cell
        end
    end
    
    always @(posedge RE) begin
        if (RE) begin
            // Output the stored value
            // No specific action needed here, Q is already assigned
        end
    end
endmodule