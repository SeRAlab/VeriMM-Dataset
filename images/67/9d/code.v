module up_counter (clk, reset, count);
   input clk;
   input reset;
   output [3:0] count;
   
   reg [3:0] count;

always @(posedge clk) begin
    if (reset)
        count <= 4'b0000;
    else
        count <= count + 1;
end

endmodule