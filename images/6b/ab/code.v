module top_module(out);output out;
   reg	  out;

   task set;
      input val;
      begin
	 #1 out = val;
      end
   endtask

endmodule