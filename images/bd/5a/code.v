module top_module(
    input clk,
    input rst,
    input [15:0] in_data,
    output [15:0] out_data
);reg [15:0] out_data_reg;

always @(posedge clk) begin
    if (rst) begin
        out_data_reg <= 0;
    end else begin
        out_data_reg <= ~in_data;
    end
end

assign out_data = out_data_reg;

endmodule