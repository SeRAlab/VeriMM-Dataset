module shift_register (clk, reset, load, shift_left, shift_right, parallel_in, q);
   input clk;
   input reset;
   input load;
   input shift_left;
   input shift_right;
   input [3:0] parallel_in;
   output [3:0] q;
   
   reg [3:0] q;

always @(posedge clk) begin
    if (reset)
        q <= 4'b0000;
    else if (load)
        q <= parallel_in;
    else if (shift_left)
        q <= {q[2:0], 1'b0};
    else if (shift_right)
        q <= {1'b0, q[3:1]};
end

endmodule