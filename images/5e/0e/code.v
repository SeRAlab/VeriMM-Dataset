module top_module(input MID_CLK, input seg_pointer, output reg anode0 = 0, output reg anode1 = 0);always@ (posedge MID_CLK) begin
        
       if(seg_pointer == 0)begin 
         anode0 <= 1;
         anode1 <= 0;
     end       
        if(seg_pointer == 1) begin 
            anode0 <= 0;
            anode1 <= 1;

        end
   end
endmodule