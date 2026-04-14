module FlashMemoryCell (
    input wire clk,
    input wire rst,
    input wire WE,
    input wire [7:0] D,
    output reg [7:0] Q
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        Q <= 8'b00000000; // Initialize memory cell to zero
    end else if (WE) begin
        Q <= D; // Write data to memory cell
    end
end

endmodule