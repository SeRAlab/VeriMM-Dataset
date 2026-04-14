module register (
    input clk,
    input sreset,
    input load_enable,
    input [7:0] data,
    output [7:0] q );reg [7:0] q_reg;

always @(posedge clk) begin
    if (sreset)
        q_reg <= 8'b01010101;
    else if (load_enable)
        q_reg <= data;
end

assign q = q_reg;

endmodule