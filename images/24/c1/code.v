module sram_cell(
    input wire clk,
    input wire en,
    input wire we,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);

reg [15:0] memory;

always @(posedge clk) begin
    if (en) begin
        if (we) begin
            memory <= data_in;  // Write data to memory
        end else begin
            data_out <= memory;  // Read data from memory
        end
    end
end

endmodule