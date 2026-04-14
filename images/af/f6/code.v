module top_module(true, complement);parameter data_channel = 1; 
  parameter data_width = 17; 
  input [data_channel * data_width - 1 : 0] true; 
  output [data_channel * data_width - 1 : 0] complement; 

  genvar i; 
  generate 
    for (i = 0; i < data_channel; i = i + 1) begin : gen_block
      localparam high = (i + 1) * data_width - 1; 
      localparam low = i * data_width; 

      assign complement[high : low] = (true[high] == 1'b0) ?
                                       true[high : low] :
                                       {1'b1, (~true[high - 1 : low] + 1'b1)};
    end 
  endgenerate 
endmodule