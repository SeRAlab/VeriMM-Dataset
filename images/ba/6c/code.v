module ram_256x10
(
    input clk,
    input wr_en,
    input rd_en,
    input [7:0] addr,
    input [9:0] data_in,
    output reg [9:0] data_out
);

reg [9:0] ram [255:0];

always @(posedge clk) begin
    if (wr_en) begin
        ram[addr] <= data_in;
    end
    if (rd_en) begin
        data_out <= ram[addr];
    end
end

endmodule