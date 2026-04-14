module DRAM_cell (
    input wire [3:0] D,      // 4-bit data input
    input wire WE,           // Write Enable
    input wire RE,           // Read Enable
    output reg [3:0] Q       // 4-bit data output
);
    always @ (posedge WE) begin
        if (WE) begin
            Q <= D;          // Write data to Q when WE is high
        end
    end
    
    always @ (posedge RE) begin
        if (RE) begin
            Q <= Q;          // Read the data from Q when RE is high
        end
    end
endmodule