module shift_reg_8bit (clk, rst, en, ld, si, pi, q);
   input clk, rst, en, ld, si;
   input [7:0] pi;
   output [7:0] q;

   reg [7:0] q;

always @(posedge clk) begin
    if (rst) begin
        q <= 8'b00000000;
    end else if (ld) begin
        q <= pi;
    end else if (en) begin
        q <= {si, q[7:1]};
    end
end

endmodule