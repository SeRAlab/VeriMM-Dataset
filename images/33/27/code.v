module dram_cell(
    input wire D,
    input wire WE,
    input wire RE,
    output reg Q
);
    always @(posedge WE or posedge RE) begin
        if (WE) begin
            Q <= D;  // Write data
        end
    end
    
    always @(posedge RE) begin
        if (RE) begin
            // Read data
            // Q will automatically output the stored value
        end
    end
endmodule