module SRAM_Cell (
    input wire [15:0] D,      // Data input
    input wire WE,            // Write enable
    input wire RE,            // Read enable
    input wire RST,           // Reset
    output reg [15:0] Q       // Data output
);
    always @(posedge RST or posedge WE) begin
        if (RST) begin
            Q <= 16'b0;       // Reset to zero
        end else if (WE) begin
            Q <= D;           // Write data
        end
    end

    always @(posedge RE) begin
        if (RE) begin
            // Output the current value of Q
            // Q is updated in the first always block
        end
    end
endmodule