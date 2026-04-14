module dram_cell (
    input wire [3:0] D,      // 4-bit data input
    input wire WE,           // Write Enable
    input wire RE,           // Read Enable
    output reg [3:0] Q       // 4-bit data output
);
    always @(posedge WE or posedge RE) begin
        if (WE) begin
            Q <= D;           // Store data on write enable
        end else if (RE) begin
            Q <= Q;           // Output current stored data on read enable
        end
        // If neither WE nor RE is high, Q remains unchanged
    end
endmodule