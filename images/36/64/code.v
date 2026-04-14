module SRAM_Cell(
    input wire clk,
    input wire we,      // Write enable
    input wire data_in, // Data input
    output reg data_out // Data output
);

reg stored_data; // Internal storage

always @(posedge clk) begin
    if (we) begin
        stored_data <= data_in; // Store data when write enable is high
    end
end

always @(*) begin
    data_out = stored_data; // Output the stored data
end

endmodule