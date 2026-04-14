module top_module(reset,clk,in_seq,out_seq);input reset;
input clk;
input in_seq;
output out_seq;


parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;
reg out_seq;

reg [1:0] state; 
reg [1:0] next_state; 

always @(posedge clk)
begin
if(reset)
state <=S0;
else
state <=next_state;
end

always @ (state or in_seq)
begin 
next_state = 2'b00;
case(state)

  S0 : if (in_seq == 1'b0) 
  begin
  next_state = S0;
  out_seq = 1'b0;
  end 
  else begin
  next_state = S1;
  out_seq = 1'b0;
  end

  S1 : if (in_seq == 1'b0) 
  begin
  next_state = S0;
  out_seq = 1'b0;
  end 
  else begin
  next_state = S2;
  out_seq = 1'b0;
  end

  S2 : if (in_seq== 1'b0) 
  begin
  next_state = S0; out_seq = 1'b1;
  end 
  else begin
  next_state = S1; out_seq = 1'b0;
  end

  default:begin
  next_state=S0;out_seq=1'b0;
  end
endcase
end


always @ (posedge clk)
begin 
if (reset == 1'b1) 
state <= S0;
else 
state <= next_state;
end
endmodule