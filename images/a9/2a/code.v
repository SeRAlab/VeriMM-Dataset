module pipo_register (
    input clk,
    input resetn,
    input [3:0] data_in,
    output reg [3:0] data_out);always @(posedge clk) begin
    if (~resetn)
        data_out <= 4'b0000;
    else
        data_out <= data_in;
end
endmodule