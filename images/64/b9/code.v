module top_module (
    input clk,
    input sreset,
    input load,
    input [7:0] reset_value,
    input [7:0] data,
    output [7:0] q );reg [7:0] q_reg;

always @(posedge clk) begin
    if (sreset)
        q_reg <= reset_value;
    else if (load)
        q_reg <= data;
end

assign q = q_reg;

endmodule