module sram_cell (
    input wire [3:0] data,
    input wire we,
    output reg [3:0] q
);

always @(posedge we) begin
    if (we) begin
        q <= data; // Write data to SRAM when we is high
    end
end

endmodule