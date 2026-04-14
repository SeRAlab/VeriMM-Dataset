module top_module( 
    input [23:0] data, 
    input blank, 
    input hs, 
    input vs,
    input clk3, 
    output reg [7:0] data3, 
    output blank3, 
    output hs3, 
    output vs3
  );reg hs_reg;
reg hs_reg1;
reg blank_reg;
reg vs_reg;
always @(posedge clk3) begin
  hs_reg <= hs;
  hs_reg1 <= hs_reg;
  vs_reg <= vs;
  blank_reg <= blank;
end

reg [1:0] cnt;

wire sync_pulse = (hs_reg & !hs_reg1) ? 1 : 0;
always @(posedge clk3) begin
  if (sync_pulse) begin
    cnt <= 2; 
  end
  else begin
    if (cnt == 2)
      cnt <= 0;
    else    
      cnt <= cnt+1;
  end
end

reg [23:0] data_reg;
always @(posedge clk3) begin
  if (cnt == 2)
    data_reg <= data;
end

always @(posedge clk3) begin
  case ( cnt )
    0 : data3 <= data_reg[7:0]; 
    1 : data3 <= data_reg[15:8]; 
    default : data3 <= data_reg[23:16]; 

  endcase
end

assign blank3 = blank_reg;
assign hs3 = hs_reg;
assign vs3 = vs_reg;

endmodule