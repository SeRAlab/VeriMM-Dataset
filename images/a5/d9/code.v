module top_module(clk,rst,en,money,beverage,change,finish);input             clk,rst,en;
  input       [5:0] money,beverage;
  output reg  [5:0] change;
  output reg        finish;
  
  reg [1:0] phase;
  reg [5:0] money_temp;
 

  
   always@(posedge rst or posedge clk)begin
       if(rst) begin
          phase <= 2'd0;
          money_temp <= 6'd0;
       end
       else  begin
		if(phase == 2'd0 && en == 1'b1) begin
         phase <= 2'd1;
         money_temp <= money;
       end
        if(phase == 2'd1) begin
          phase <= 2'd2;
          money_temp <= money_temp - beverage; 
       end
       if(phase == 2'd2) begin
          phase <= 2'd0;
          money_temp <= 6'd0;
     end
		end
end
always@(*)begin    
	if(phase == 2'd2) begin
		change = money_temp;
		finish = 1'b1;
	 end
	 else begin
		change = money_temp;
        finish = 1'b0;
end
end
endmodule