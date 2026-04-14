module top_module(
  input rst_n, clock, d_in,
  output found
);reg [3:0] cstate;

  always @( posedge clock) begin
    if (!rst_n)
      cstate <= 0;
    else if (cstate == 0) begin
      if (d_in)
        cstate <= 1;
      else 
	cstate <= 0;
    end
    else if (cstate == 1) begin
      if (d_in)
        cstate <= 2;
      else 
	cstate <= 0;
    end
    else if (cstate == 2) begin
      if (d_in)
        cstate <= 2;
      else 
	cstate <= 3;
    end
    else if (cstate == 3) begin
      if (d_in)
        cstate <= 4;
      else 
	cstate <= 0;
    end
    else if (cstate == 4) begin
      if (d_in)
        cstate <= 2;
      else 
	cstate <= 0;
    end
    else cstate <= 0;
  end

  assign found = (cstate == 4);

endmodule