module top_module(
    input in1,
    input in2,
    input clk,
    output out
);reg out_reg;

always @(posedge clk) begin
    out_reg <= ~(in1 & in2);
end

assign out = out_reg;

endmodule