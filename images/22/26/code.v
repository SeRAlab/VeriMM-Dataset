module sram_cell (
    input wire clk,
    input wire rst,
    input wire we,
    input wire d,
    output reg q
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 1'b0; // Reset value
        end else if (we) begin
            q <= d; // Write data
        end
    end
endmodule