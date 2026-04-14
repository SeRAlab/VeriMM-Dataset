module reg_8bit_with_enable (D, clk, en, Q);
   input [7:0] D;
   input clk, en;
   output reg [7:0] Q;

always @(posedge clk) begin
    if (en)
        Q <= D;
end

endmodule