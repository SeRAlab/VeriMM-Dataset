module sram_cell (
    input wire [3:0] data_in,
    input wire we,
    output reg [3:0] data_out
);
    always @(posedge we) begin
        data_out <= data_in;  // Store data when write enable is high
    end
endmodule