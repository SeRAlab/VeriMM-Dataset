module flash_memory_cell (
    input wire clk,
    input wire we,          // Write Enable
    input wire d,          // Data input
    output reg q           // Data output
);
    always @(posedge clk) begin
        if (we) begin
            q <= d;        // Write data to memory cell
        end
    end
endmodule