module memory (
    input clk,
    input write_enable,
    input [7:0] address,
    input [7:0] data_in,
    output [7:0] data_out );reg [7:0] mem [0:255];
reg [7:0] data_out_reg;

always @(posedge clk) begin
    if (write_enable)
        mem[address] <= data_in;
    data_out_reg <= mem[address];
end

assign data_out = data_out_reg;

endmodule