module divide_by_2 (
    input wire clk,      // Clock input
    input wire rst,      // Reset input
    input wire in,       // 1-bit input
    output reg out       // 1-bit output
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        out <= 0;        // Asynchronous reset
    end else begin
        out <= in;       // Output follows the input
    end
end

endmodule