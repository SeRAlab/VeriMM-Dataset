module top_module(ifclk, fifoadr, data, rd, empty,data_in, data_wr, data_commit, send_done);parameter FIFOADDR = 2; 
  parameter EMPTY_LEVEL = 1; 
  input ifclk; 
  input rd; 
  input [1:0] fifoadr; 
  output [7:0] data; 
  output empty; 
  input [7:0] data_in; 
  input data_wr; 
  input data_commit; 
  output send_done; 
  reg [7:0] buffer [1024:0]; 
  reg [8:0] length; 
  reg [8:0] tail; 
  reg [8:0] head; 
  wire data_waiting = (length != 0); 
  wire send_done = (tail == length) && data_waiting; 
  wire empty = ((length-tail) <= EMPTY_LEVEL); 
  initial length = 0; 
  initial tail = 0; 
  initial head = 0; 
  always @(posedge ifclk) 
  begin 
  if ((fifoadr == FIFOADDR) && rd && data_waiting) 
  begin 
  tail <= tail + 1; 
  end 
  if (send_done) 
  begin 
  length <= 0; 
  tail <= 0; 
  end 
  end 
  always @(posedge ifclk) 
  begin 
  if (data_wr) 
  begin 
  buffer[head] <= data_in; 
  head <= head + 1; 
  end 
  if (data_commit) 
  begin 
  length <= head; 
  head <= 0; 
  end 
  end 
  assign data = data_waiting ? buffer[tail] : 8'hZZ; 
 endmodule