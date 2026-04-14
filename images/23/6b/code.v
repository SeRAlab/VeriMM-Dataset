module SRAM_Cell (
    input [3:0] data_in,
    input we,
    output reg [3:0] data_out
);
    always @(posedge we) begin
        data_out <= data_in; // Store data on rising edge of write enable
    end
endmodule