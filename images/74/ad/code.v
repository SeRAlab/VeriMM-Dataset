module top_module(
    input clk,
    input rst,
    input en,
    input [3:0] in,
    output [2:0] out
);reg [3:0] reg_in;
reg [2:0] reg_out;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        reg_in <= 4'b0;
        reg_out <= 3'b0;
    end
    else if (en) begin
        reg_in <= in;
        reg_out <= {reg_in[3], reg_in[2], reg_in[1]};
    end
end

assign out = reg_out;

endmodule