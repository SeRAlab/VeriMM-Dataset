module sram_cell (
    input wire [3:0] data_in,
    output reg [3:0] data_out,
    input wire we,
    input wire clk,
    input wire reset
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_out <= 4'b0000; // Reset output to 0
    end else if (we) begin
        data_out <= data_in; // Write data to SRAM
    end
end

endmodule