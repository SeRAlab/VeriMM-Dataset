module top_module(
                clk, reset,
                in0,
                in1,
                out_3_4,
                config_addr,
                config_data,
                config_en
                );input  clk;
  input  reset;
  input  config_en;
  input [31:0] config_data;

  
  
  
  
  
  
  input [31:0] config_addr;
  

  output [0:0] out_3_4;
   input [0:0] in0;

   input [0:0] in1;
   

  reg [95:0] config_sb;
  
  always @(posedge clk) begin
    if (reset==1'b1) begin

      config_sb <= 96'd0;

    end else begin
       config_sb <= 96'd1;
       
      
      
      
      
      

      

      
      
    end
  end

  assign out_3_4 = config_sb[79] ? in0 : in1; 

endmodule