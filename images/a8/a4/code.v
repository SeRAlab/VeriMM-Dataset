module d_flip_flop (Q, D, clk, reset);
   input D, clk, reset;
   output Q;
   
   reg Q;

always @(posedge clk or posedge reset) begin
    if (reset) 
        Q <= 1'b0;
    else 
        Q <= D;
end

endmodule