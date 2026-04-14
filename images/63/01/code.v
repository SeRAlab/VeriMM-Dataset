module top_module(input [7:0] x,input ci,input [3:0] y,input e,output reg [7:0] w,output reg co);always @(x or ci or y or e) 
  case (y) 
  default: {co,w} <= {ci,x}; 
  5'd01: {co,w} <= e ? {x[0], ci, x[7:1]} : {ci, x[0], x[7:1]}; 
  5'd02: {co,w} <= e ? {x[1:0], ci, x[7:2]} : {ci, x[1:0], x[7:2]}; 
  5'd03: {co,w} <= e ? {x[2:0], ci, x[7:3]} : {ci, x[2:0], x[7:3]}; 
  5'd04: {co,w} <= e ? {x[3:0], ci, x[7:4]} : {ci, x[3:0], x[7:4]}; 
  5'd05: {co,w} <= e ? {x[4:0], ci, x[7:5]} : {ci, x[4:0], x[7:5]}; 
  5'd06: {co,w} <= e ? {x[5:0], ci, x[7:6]} : {ci, x[5:0], x[7:6]}; 
  5'd07: {co,w} <= e ? {x[6:0], ci, x[7]} : {ci, x[6:0], x[7]}; 
  5'd08: {co,w} <= {x,ci}; 
  endcase 
 endmodule