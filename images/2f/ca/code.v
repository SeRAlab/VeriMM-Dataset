module sram_cell (
    input [7:0] data,
    input we,
    output reg [7:0] q
);
    always @(we or data) begin
        if (we) begin
            q <= data; // Write data to SRAM cell
        end
    end
endmodule