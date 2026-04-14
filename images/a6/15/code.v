module top_module(
    input clk_i,
    input [15:0] data_i,
    input [SIZE-1:0] address_i,
    input [1:0] be_i,
    input wren_i,
    output reg [15:0] data_o
);parameter [31:0] SIZE = 18;

reg [7:0] ram_ub [(1 << SIZE) - 1:0];
reg [7:0] ram_lb [(1 << SIZE) - 1:0];

always @(posedge clk_i) begin
    if (wren_i) begin
        if (!be_i[0] && !be_i[1]) begin
            ram_lb[address_i] <= data_i[7:0];
            ram_ub[address_i] <= data_i[15:8];
        end else if (!be_i[0]) begin
            ram_lb[address_i] <= data_i[7:0];
        end else if (!be_i[1]) begin
            ram_ub[address_i] <= data_i[15:8];
        end
    end
end

assign data_o = {ram_ub[address_i], ram_lb[address_i]};

endmodule