module top_module(trigger, output_xhdl0, globalreset, clk, enable);input trigger; 
    output reg output_xhdl0;  // Change to reg to allow assignment
    input globalreset; 
    input clk; 
    input enable; 

    reg[1:0] state; 
    reg[1:0] next_state; 
    reg count; 
    reg temp_count; 

    always @(posedge clk or posedge globalreset)
    begin
       if (globalreset == 1'b1)
       begin
          state <= 0 ; 
          count <= 0 ; 

       end
       else
       begin
          state <= next_state ; 
		  count <= temp_count;
       end 
    end 

    always @(state or trigger or count or enable)
    begin
       case (state)
          0 :
                   begin
                      output_xhdl0 = 1'b0 ; 
                      if (trigger == 1'b1 && enable == 1'b1)
                      begin
                         next_state = 1 ; 
                      end
                      else
                      begin
                         next_state = 0 ; 
                      end 
                      temp_count = 1 - 1 ; 
                   end
          1 :
                   begin
                      output_xhdl0 = enable; 
                      if (count == 0)
                      begin
                         next_state = 2 ; 
                      end
                      else
                      begin
                         next_state = 1 ; 
                      end 
                      temp_count = count - 1 ; 
                   end
          2 :
                   begin
                      output_xhdl0 = 1'b0 ; 
                      if (trigger == 1'b0)
                      begin
                         next_state = 0 ; 
                      end
                      else
                      begin
                         next_state = 2 ; 
                      end 
                   end
       endcase 
    end 
endmodule