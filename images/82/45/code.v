module top_module(
                     
                     input wire           clk,
                     input wire           reset_n,

                     
                     input wire           cs,
                     input wire           we,

                     
                     input wire  [7 : 0]  address,
                     input wire  [31 : 0] write_data,
                     output wire [31 : 0] read_data,

                     output wire          ready,
                     output wire          warning,
                     output wire          error
                     );localparam ADDR_NAME0       = 8'h00;
  localparam ADDR_NAME1       = 8'h01;
  localparam ADDR_VERSION     = 8'h02;

  localparam CORE_NAME0       = 32'h6f6c5f74; 
  localparam CORE_NAME1       = 32'h65737420; 
  localparam CORE_VERSION     = 32'h302e3130; 


  
  
  


  
  
  


  
  
  


  
  
  


  
  
  


  
  
  
  
  
  
  always @ (posedge clk or negedge reset_n)
    begin
      if (!reset_n)
        begin
        end
      else
        begin
        end
    end 

endmodule