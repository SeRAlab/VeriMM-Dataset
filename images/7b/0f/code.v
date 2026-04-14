module top_module(index_i, data_o);input       [5:0] index_i;    
   output reg  [16:0] data_o;    
                                 
                                 
                                 
                                 
   always @* begin
      (* parallel_case *) case(index_i)
         
         6'd0 : data_o = {16'h1280, 1'b1};   
         6'd1 : data_o = {16'hf0f0, 1'b1};   
         6'd2 : data_o = {16'h1180, 1'b1};   
         6'd3 : data_o = {16'h1205, 1'b1};   
         
          
        default: data_o = {16'hffff, 1'b1};
      endcase
   end

endmodule