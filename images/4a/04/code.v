module top_module(
       input increment,
		 input decrement,
		 input clk,
		 input reset,
		 output reg[1:0] count
    );reg enable;
reg[1:0] mux_out;

always@(*)
enable=increment|decrement;

always@(*)
begin
case(increment)
1'b0:mux_out=count+1;
1'b1:mux_out=count-1;
endcase
end

always@(posedge clk)
begin
if(reset)
count<=#1 0;
else if(enable)
count<=mux_out;
end

endmodule