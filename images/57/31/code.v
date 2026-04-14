module top_module(input clk,
              input reset,
              input [1:0] WB2_input, 
              input [2:0] M2_input, 
              input [31:0] ALU_input, 
              input [4:0] instruction_mux_in, 
              input [31:0] RdData2_in, 
              output reg[2:0] M2_output, 
              output reg[1:0] WB2_output, 
              output reg[31:0] ALU_output, 
              output reg[4:0] instruction_mux_out, 
              output reg[31:0] RdData2_out);always@ (posedge reset) begin 
      WB2_output = 0; 
      M2_output =0 ; 
      ALU_output = 0; 
      RdData2_out = 0; 
      instruction_mux_out = 0; 
   end 
    
    
    always@(posedge clk) begin 
      if (reset == 0) begin
        WB2_output <= WB2_input; 
        M2_output <= M2_input; 
        ALU_output <= ALU_input; 
        RdData2_out <= RdData2_in; 
        instruction_mux_out <= instruction_mux_in; 
    end 
  end
 
endmodule