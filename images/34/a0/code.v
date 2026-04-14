module dram_cell (
    input wire WE,
    input wire RE,
    input wire [3:0] D,
    output reg [3:0] Q
);
    always @(posedge WE or posedge RE) begin
        if (WE) begin
            Q <= D; // Store D when WE is high
        end else if (RE) begin
            // Output Q when RE is high, do nothing else
            // Q will maintain its value from previous write
        end
    end
endmodule