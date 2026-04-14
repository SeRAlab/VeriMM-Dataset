module top_module( clk,rot_a,rot_b,r_event
    );input clk;
	  input rot_a;
	  input rot_b;
	  output r_event;
	  reg r_event;
	  always @(posedge clk) begin
	  if(rot_a==1 && rot_b==1) begin
	    r_event <= 1;
	    end
	  if(rot_a==0 && rot_b==0) begin
	    r_event <= 0;
	    end
	  end

endmodule