module sram_cell (
    input wire d,
    input wire we,
    input wire clk,
    output reg q
);
    always @(posedge clk) begin
        if (we) begin
            q <= d;  // Write operation
        end
        // else no action, hold the current value
    end
endmodule