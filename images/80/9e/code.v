module top_module(FIFO_EN,DMA_MODE,data_in_1,data_in_2,m_clk,reset,data_out);input wire FIFO_EN,DMA_MODE;
input wire m_clk;
input wire [7:0] data_in_1;
input wire [7:0] data_in_2;
input wire reset;
output reg [7:0] data_out;

wire select_line=DMA_MODE & FIFO_EN;

always @(posedge m_clk)
 begin 
 if(reset==1'b1)
  begin data_out<=8'h00;
  end
case (select_line)
1'b0: data_out<=data_in_1;
1'b1: data_out<=data_in_2;
endcase
end
endmodule