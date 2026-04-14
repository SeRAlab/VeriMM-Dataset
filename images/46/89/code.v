module top_module(distance,
                       data,
                       direction,
                       result);parameter             lpm_type = "LPM_CLSHIFT";
   parameter             lpm_shifttype = "ARITHMETIC";
   parameter             lpm_width = 32;
   parameter             lpm_widthdist = 5;
   
   input  wire [lpm_widthdist-1:0] distance;
   input  signed [lpm_width-1    :0] data;
   input  wire                     direction;
   output wire [lpm_width-1    :0] result;

   wire   [lpm_width-1    :0] lsh    = data << distance;
   wire   [lpm_width-1    :0] rsh    = data >> distance;
   wire   [lpm_width-1    :0] rshN   = ~(~data >> distance);
   wire   [lpm_width-1    :0] arsh   = data[lpm_width-1] ? rshN : rsh;
   assign                     result = direction ? arsh : lsh;
   
endmodule