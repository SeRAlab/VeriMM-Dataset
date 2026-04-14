module top_module(
           CLK_IN,
           reset,
           enb_1_2000_0,
           cMode,
           index,
           reset_1
          );input   CLK_IN;
  input   reset;
  input   enb_1_2000_0;
  input   [1:0] cMode;  
  output  [1:0] index;  
  output  reset_1;

  parameter [1:0] controllerModeEnum_VelocityControl = 2;  
  parameter [1:0] controllerModeEnum_OpenLoopVelocityControl = 3;  

  reg [1:0] index_1;  
  reg  reset_2;
  reg [1:0] index_n1;  
  reg [1:0] index_n1_next;  
  reg [1:0] index_2;  


  always @(posedge CLK_IN)
    begin : MATLAB_Function_process
      if (reset == 1'b1) begin
        index_n1 <= 2'b10;
      end
      else if (enb_1_2000_0) begin
        index_n1 <= index_n1_next;
      end
    end

  always @(cMode, index_n1) begin
    
    
    if (cMode == controllerModeEnum_OpenLoopVelocityControl) begin
      
      index_2 = 2'b00;
    end
    else if (cMode == controllerModeEnum_VelocityControl) begin
      
      index_2 = 2'b01;
    end
    else begin
      
      index_2 = 2'b10;
    end
    if (index_2 != index_n1) begin
      
      reset_2 = 1'b1;
    end
    else begin
      
      reset_2 = 1'b0;
    end
    
    index_n1_next = index_2;
    index_1 = index_2;
  end



  assign index = index_1;

  assign reset_1 = reset_2;

endmodule