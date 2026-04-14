module top_module(input wire clk,input wire [2:0] octave,input wire [8:0] freq,output reg out,output reg pulseout);reg [7:0] fcounter; 
  always @* begin 
  case (octave) 
  3'd0: fcounter = 8'd255; 
  3'd1: fcounter = 8'd127; 
  3'd2: fcounter = 8'd63; 
  3'd3: fcounter = 8'd31; 
  3'd4: fcounter = 8'd15; 
  3'd5: fcounter = 8'd7; 
  3'd6: fcounter = 8'd3; 
  3'd7: fcounter = 8'd1; 
  endcase 
  end 
  reg [7:0] count = 8'd0; 
  always @(posedge clk) begin 
  if (count == fcounter) 
  count <= 8'd0; 
  else 
  count <= count + 1; 
  end 
  reg pulse; 
  always @* begin 
  if (count == fcounter) 
  pulse = 1'b1; 
  else 
  pulse = 1'b0; 
  end 
  initial out = 1'b0; 
  reg [8:0] cfinal = 9'd0; 
  always @(posedge clk) begin 
  if (pulse == 1'b1) begin 
  if (cfinal == freq) begin 
  cfinal <= 9'd0; 
  out <= ~out; 
  end 
  else 
  cfinal <= cfinal + 1; 
  end 
  end 
  always @* begin 
  if (pulse == 1'b1 && cfinal == freq) 
  pulseout = 1'b1; 
  else 
  pulseout = 1'b0; 
  end 
 endmodule