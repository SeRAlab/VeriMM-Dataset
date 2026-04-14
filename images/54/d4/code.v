module top_module(
    input value,
    output [0:3] an,
    output [0:6] segments
    );assign an[0] = value ? "0" : "0";
		assign an[1] = value ? "0" : "0";
		assign an[2] = value ? "1" : "1";
		assign an[3] = value ? "1" : "1";
		
	  assign segments[0] = value ? 1 : 0;
     assign segments[1] = value ? 0 : 0;
     assign segments[2] = value ? 0 : 1;
     assign segments[3] = value ? 1 : 0;
     assign segments[4] = value ? 1 : 0;
     assign segments[5] = value ? 1 : 1;
     assign segments[6] = value ? 1 : 0;
     
endmodule