module top_module(
   input clk,
   output reg genclk
);reg [7:0] cyc; 
initial cyc = 0;
wire genthiscyc = ( (cyc % 2) == 1 );

always @ (posedge clk) begin
   cyc <= cyc + 8'h1;
   genclk <= genthiscyc;
end

always @ (posedge genclk) begin
   cyc <= 0;
end

endmodule