module top_module(
   
   clk, toggle
   );input clk;
   input toggle;

   

   always @ (posedge clk) begin
      center_task(1'b0);
   end

   task center_task;
      input external;
      begin
	 if (toggle) begin
	    
	 end
	 if (external) begin
	    
	    $write("[%0t] Got external pulse\n", $time);
	 end
      end
   endtask

endmodule