module top_module(input reset,input i_clock,input i_data,output scan_ready,output [7:0] scan_code);reg [7:0] r_scan_code; 
  reg [3:0] counter; 
  reg ready; 
  assign scan_code = r_scan_code; 
  assign scan_ready = ready; 
  always @(negedge i_clock or posedge reset) begin 
  if (reset) begin 
  r_scan_code = 8'b0; 
  counter = 4'd0; 
  end else begin 
  if (counter == 4'd0) begin 
  ready = 1'b0; 
  r_scan_code = 8'b0; 
  counter = counter + 4'd1; 
  end else if (counter == 4'd9) begin 
  if (!i_data == ^r_scan_code) begin 
  ready = 1'b1; 
  end 
  counter = counter + 4'd1; 
  end else if (counter == 4'd10) begin 
  counter = 4'd0; 
  end else begin 
  r_scan_code[counter] = i_data; 
  counter = counter + 4'd1; 
  ready = 1'b0; 
  end 
  end 
  end 
 endmodule