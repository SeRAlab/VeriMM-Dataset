module top_module(input [2:0] decod_38_in,output reg [7:0] decod_38_out);always @(decod_38_in ) begin 
  case(decod_38_in) 
  3'd0: decod_38_out = ~8'h01; 
  3'd1: decod_38_out = ~8'h02; 
  3'd2: decod_38_out = ~8'h04; 
  3'd3: decod_38_out = ~8'h08; 
  3'd4: decod_38_out = ~8'h10; 
  3'd5: decod_38_out = ~8'h20; 
  3'd6: decod_38_out = ~8'h40; 
  3'd7: decod_38_out = ~8'h80; 
  default: decod_38_out = ~8'h00; 
  endcase 
  end 
 endmodule