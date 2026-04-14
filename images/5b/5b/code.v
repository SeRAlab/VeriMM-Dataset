module top_module(
    input clk,
    input rstn,
    
    input [31:0] f0,
    
    output[15:0] m_axis_phase_tdata,
    output       m_axis_phase_tvalid
    );reg [31 : 0] phase;
    
    
    reg [47:0] tmp_reg_0, tmp_reg_1; 
    always @(posedge clk)
      if (!rstn) begin
         phase     <= 0;
         tmp_reg_0 <= 0;
         tmp_reg_1 <= 0;
      end else begin
       
        
        tmp_reg_0 <= f0 * 7'd107;
        tmp_reg_1 <= tmp_reg_0 >> 7; 
          phase   <= tmp_reg_1; 
      end   
    
      
      
      
      assign m_axis_phase_tvalid = 1;
      assign m_axis_phase_tdata  = phase >> 7;
    
    
    
endmodule