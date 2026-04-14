module top_module(
    input clock,
    input [23:0] data_in,
    input [9:0] wr_address,
    input wr_en,
    input [9:0] rd_address,
    output reg [23:0] q
);reg [23:0] ram [0:1023];

always @(posedge clock) begin
    if (wr_en) begin
        ram[wr_address] <= data_in;
    end
    q <= ram[rd_address];
end

endmodule