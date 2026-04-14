module dram_cell (
    input wire [7:0] D,    // 8-bit data input
    input wire WE,         // Write enable
    input wire RE,         // Read enable
    output reg [7:0] Q     // 8-bit data output
);
    always @ (posedge WE or posedge RE) begin
        if (WE) begin
            Q <= D;         // Write data to cell
        end
    end

    always @ (posedge RE) begin
        if (RE) begin
            Q <= Q;         // Read data from cell (output remains unchanged)
        end
    end
endmodule