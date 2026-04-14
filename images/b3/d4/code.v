module top_module(
out,
reset,
clk,
check
    );output[7:0] out;
 output check;
 input reset, clk;
 reg[7:0] out;
 reg check;
 always @(posedge clk)
    begin
    if (reset) out <= 0;    


    else {check, out} = out + 1;
    end
endmodule