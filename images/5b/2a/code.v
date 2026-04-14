module top_module(i_oe,
            i_data,
            o_data);parameter DATA_WIDTH = 8;

   input  wire                  i_oe;    
   input  wire [DATA_WIDTH-1:0] i_data;  
   output wire [DATA_WIDTH-1:0] o_data;  

   
   assign o_data = (i_oe) ? i_data : 0;

endmodule