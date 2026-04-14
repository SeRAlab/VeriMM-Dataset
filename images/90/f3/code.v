module top_module(
  address,
  length,
  maximum_burst_count,
  short_first_access_enable,
  short_last_access_enable,
  short_first_and_last_access_enable,

  burst_count
);parameter BURST_ENABLE = 1;      
  parameter BURST_COUNT_WIDTH = 3;
  parameter WORD_SIZE_LOG2 = 2;    
  parameter ADDRESS_WIDTH = 32;
  parameter LENGTH_WIDTH = 32;
  parameter BURST_WRAPPING_SUPPORT = 1;  
  localparam BURST_OFFSET_WIDTH = (BURST_COUNT_WIDTH == 1)? 1: (BURST_COUNT_WIDTH-1);

  input [ADDRESS_WIDTH-1:0] address;
  input [LENGTH_WIDTH-1:0] length;
  input [BURST_COUNT_WIDTH-1:0] maximum_burst_count;  
  input short_first_access_enable;
  input short_last_access_enable;
  input short_first_and_last_access_enable;

  output wire [BURST_COUNT_WIDTH-1:0] burst_count;


  wire [BURST_COUNT_WIDTH-1:0] posted_burst;   
  reg [BURST_COUNT_WIDTH-1:0] internal_burst_count;  
  wire burst_of_one_enable;     
  wire short_burst_enable;
  wire [BURST_OFFSET_WIDTH-1:0] burst_offset;


  assign burst_offset = address[BURST_OFFSET_WIDTH+WORD_SIZE_LOG2-1:WORD_SIZE_LOG2];

  
  assign burst_of_one_enable = (short_first_access_enable == 1) | (short_last_access_enable == 1) | (short_first_and_last_access_enable == 1) |  
                               ((BURST_WRAPPING_SUPPORT == 1) & (burst_offset != 0));  
  assign short_burst_enable = ((length >> WORD_SIZE_LOG2) < maximum_burst_count);

generate
  if ((BURST_ENABLE == 1) & (BURST_COUNT_WIDTH > 1))
  begin
   
    always @ (maximum_burst_count or length or short_burst_enable or burst_of_one_enable)
    begin
    case ({short_burst_enable, burst_of_one_enable})
      2'b00 : internal_burst_count = maximum_burst_count;
      2'b01 : internal_burst_count = 1;  
      2'b10 : internal_burst_count = ((length >> WORD_SIZE_LOG2) & {(BURST_COUNT_WIDTH-1){1'b1}});  
      2'b11 : internal_burst_count = 1;  
    endcase
    end
 
    assign burst_count = internal_burst_count;
  end
  else
  begin
    assign burst_count = 1;  
  end
endgenerate

endmodule