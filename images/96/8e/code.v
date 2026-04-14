module top_module(date, tick, Rx, Check, Dout);input date, tick, Rx;
output Check;
output [7:0] Dout;

reg signal;
reg [7:0] data;
reg [3:0] counter = 0;
reg [7:0] Reg_Out = 0;

always @(tick)
    
    if(tick) begin
        if (date) begin
		        if(counter == 8) begin
		            signal = 1;
		            data = Reg_Out;
		            counter = 0;
		        end 
		        else begin
		        	Reg_Out = {Rx, Reg_Out[7:1]};
		        	counter = counter + 1;
		        end
        end
        else begin
			signal = 0;
        end
    end
    else
      signal = 0;
    
    assign Dout = data;
    assign Check = signal;
endmodule