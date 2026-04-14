module top_module(consumer_req, consumer_data);output consumer_req; 
  input [3:0] consumer_data; 
  reg consumer_iclk; 
  reg consumer_req; 

  always @(consumer_iclk) 
  begin 
    consumer_req = 1; 
    #1 consumer_req = 0; 
  end 

  initial 
  begin 
    consumer_req = 0; 
    consumer_iclk = 1; 
    $monitor("data consumed : %d at time = %t", consumer_data, $time); 
  end 

  always 
  begin 
    #10 consumer_iclk = ~consumer_iclk; 
  end 
endmodule