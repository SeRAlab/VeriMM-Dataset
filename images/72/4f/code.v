module top_module(
   input wire         data_i,
   input wire         operation,
   input wire [1:0]   shift_region_flag,
   output reg         sel_mux_3,
   output reg         data_out_CORDECO
 );always @(*) begin
     if(operation == 1'b0)
        begin  
          case (shift_region_flag)
            2'b00  : begin
                        sel_mux_3 = 1'b0;
                        data_out_CORDECO = data_i;
                     end
            2'b01  : begin
                        sel_mux_3 = 1'b1;
                        data_out_CORDECO = ~data_i;
                     end
            2'b10  : begin
                        sel_mux_3 = 1'b1;
                        data_out_CORDECO = data_i;
                     end
            2'b11  : begin
                        sel_mux_3 = 1'b0;
                        data_out_CORDECO = data_i;
                     end
          endcase
        end
      else begin  
          case (shift_region_flag)
            2'b00  : begin
                        sel_mux_3 = 1'b1;
                        data_out_CORDECO = data_i;
                     end
            2'b01  : begin
                        sel_mux_3 = 1'b0;
                        data_out_CORDECO = data_i;
                     end
            2'b10  : begin
                        sel_mux_3 = 1'b0;
                        data_out_CORDECO = ~data_i;
                     end
            2'b11  : begin
                        sel_mux_3 = 1'b1;
                        data_out_CORDECO = data_i;
                     end 
          endcase
      end
   end


endmodule