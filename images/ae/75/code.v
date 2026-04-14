module top_module(data,ena,clk,rst_clk,op_ir,state);input ena,clk,rst_clk;
input [7:0]data;
output [15:0] op_ir;
output [1:0]state;
reg [1:0]state;
reg [15:0] op_ir;
always @(posedge clk)
begin
  if(rst_clk == 1)
  begin
    op_ir <= 16'b0000000000000000;
    state <= 1'b0;
  end
  else
  begin
    if(ena)
    begin
      case (state)
        2'b00:
        begin
          op_ir[15:8] <= data;
          state <= 2'b01;
        end 
        2'b01:
        begin
          op_ir[7:0] <= data;
          state <= 2'b00;
        end
        default: 
        begin
          op_ir[15:0] <= 16'b0000000000000000;
          state <= 2'b11;
        end
      endcase
    end
    else
    begin
      state <= 2'b00;
    end
  end
end
endmodule