module top_module(
    input clk,
    input reset,
    input load_enable,
    input [31:0] data_in,
    output reg [31:0] reg_out);always @(posedge clk) begin
    if (reset)
        reg_out <= 32'b0;
    else if (load_enable)
        reg_out <= data_in;
end
endmodule