module flash_memory_cell (
    input wire clk,
    input wire set,
    input wire reset,
    input wire d,
    output reg q
);
    always @(posedge clk) begin
        if (set) begin
            q <= d;
        end else if (reset) begin
            q <= 1'b0;
        end
        // If both set and reset are high, keep q unchanged
    end
endmodule