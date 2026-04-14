module temp_shutdown(  
    input [6:0] temperature,  
    input reset,  
    input clk,  
    output reg shutdown  
);  

  parameter THRESHOLD = 7'd100;  

  always @(posedge clk or posedge reset) begin  
    if (reset)  
      shutdown <= 1'b0;  
    else if (temperature > THRESHOLD)  
      shutdown <= 1'b1;  
    else  
      shutdown <= 1'b0;  
  end  
endmodule