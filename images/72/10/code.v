module top_module(input clk,
              input reset,
              input[1:0] WB3_in, 
              input[31:0] ReadData_in, 
              input[31:0] ALU2_in, 
              input[4:0] instruction_mux2_in, 
              output reg[1:0] WB3_out, 
              output reg[31:0] ReadData_out, 
              output reg[31:0] ALU2_out,
              output reg[4:0] instruction_mux2_out);always@ (posedge reset) begin 
      WB3_out = 0; 
      instruction_mux2_out = 0; 
      ALU2_out = 0; 
      ReadData_out = 0;  
   end 
    
    always@ (posedge clk)  begin 
      if (reset == 0) begin
        WB3_out <= WB3_in; 
        ReadData_out <= ReadData_in; 
        ALU2_out <= ALU2_in; 
        instruction_mux2_out <= instruction_mux2_in; 
    end 
  end
    
endmodule