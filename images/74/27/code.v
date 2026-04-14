module top_module(
    input in0, in1, in2, in3, clk, reset,
    input d0, d1, d2, d3,
    output reg out0, out1, out2, out3
);reg [3:0] out_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out_reg <= 4'b0;
    end else begin
        out_reg[0] <= in0 ? d0 : out_reg[0];
        out_reg[1] <= in1 ? d1 : out_reg[1];
        out_reg[2] <= in2 ? d2 : out_reg[2];
        out_reg[3] <= in3 ? d3 : out_reg[3];
    end
end

assign out0 = out_reg[0];
assign out1 = out_reg[1];
assign out2 = out_reg[2];
assign out3 = out_reg[3];

endmodule