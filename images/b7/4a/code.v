module shift_register_16bit (q, clk, reset, sh_en, ld_en, d);
   input clk, reset, sh_en, ld_en;
   input [15:0] d;
   output [15:0] q;
   
   reg [15:0] q;

always @(posedge clk or posedge reset) begin
    if (reset)
        q <= 16'b0;
    else if (ld_en)
        q <= d;
    else if (sh_en)
        q <= q << 1;
end

endmodule