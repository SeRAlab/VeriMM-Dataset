module dram_cell (
    input wire [7:0] D,
    input wire RW,
    input wire CLK,
    input wire EN,
    output reg [7:0] Q
);
    always @(posedge CLK) begin
        if (EN) begin
            if (RW) begin
                Q <= D; // Write data
            end else begin
                // Q remains as it is (read operation)
            end
        end
    end
endmodule