module top_module(
    clk,
    rst,
    config_valid,
    config_char,
    config_chained,
    input_valid,
    input_char,
    prev_matched,
    this_matched
    );input clk;
  input rst;

  input config_valid;
  input [7:0] config_char;
  input       config_chained;

  input       input_valid;
  input [7:0] input_char;

  input       prev_matched;
  output      this_matched;

  reg         char_match;
  reg [7:0]   char_data;
  reg         is_chained;
         

  assign this_matched = char_match;
  
  always @(posedge clk)
  begin
    
    if(rst) begin
      char_data <= 0;
      char_match <= 0;
    end    
    else begin      
      
      if (input_valid==1) begin
        
        if (char_data==input_char)
          char_match <= is_chained ? prev_matched : 1;
        else
          char_match <= 0;               
        
      end
      
      if (config_valid==1) begin
        char_data <= config_char;
        is_chained <= config_chained;
        char_match <= 0;
      end
      

    end              	     
  end

endmodule