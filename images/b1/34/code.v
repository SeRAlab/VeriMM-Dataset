module top_module(
  input       i_Pclk,   
  input       i_Enable, 
  input       i_Reset,
  input       i_Done,
  input [7:0] i_Data,
  output reg       o_Ready,
  output reg       o_Busy,
  output reg [7:0] o_Data
  );always @ (posedge i_Pclk) begin
    o_Ready <= 0;
    if (i_Reset) begin 
      o_Data <= 8'b0;
      o_Busy <= 0;
    end
    if (o_Busy) begin 
      if (i_Done) begin 
        o_Busy <= 0;
      end
    end else begin 
      if (i_Enable) begin 
        o_Data <= i_Data; 
        o_Busy <= 1; 
        o_Ready <= 1; 
      end
    end
  end
endmodule