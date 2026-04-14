module dram_cell (
    input wire clk,
    input wire we,       // Write Enable
    input wire re,       // Read Enable
    input wire rst,      // Reset
    input wire [3:0] d_in, // Data input
    output reg [3:0] d_out // Data output
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        d_out <= 4'b0000; // Reset the cell
    end else if (we) begin
        d_out <= d_in; // Write the input data to the cell
    end
end

endmodule