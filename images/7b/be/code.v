module top_module(CLK,data,piped_data);parameter data_width = 32; 
  parameter pipe_steps = 0; 
  parameter keep_register_names = "YES"; 
  input wire CLK; 
  input wire [data_width-1:0] data; 
  output wire [data_width-1:0] piped_data; 
  genvar i; 
  generate 
  if (pipe_steps>0) begin 
  (* KEEP = keep_register_names *) reg [data_width-1:0] pipes [pipe_steps-1:0]; 
  always@(posedge CLK) begin 
  pipes[0] <= data; 
  end 
  for (i=1;i<pipe_steps;i=i+1) begin : SHIFTS 
  always@(posedge CLK) begin 
  pipes[i] <= pipes[i-1]; 
  end 
  end 
  assign piped_data = pipes[pipe_steps-1]; 
  end else begin 
  assign piped_data = data; 
  end 
  endgenerate 
 endmodule