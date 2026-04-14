module top_module(input signed [16:0] serIn , input [16:0] init_value , input en, input clk, input rst , input init , output reg signed [16:0] Q);always @ (posedge clk, posedge rst) begin
    
    if(rst) Q <= 17'b0;
    else if(en) Q <= serIn;
    else if(init) Q <= init_value;
  end
endmodule