module top_module(output reg [3: 0] A, input incr, clear, clock);always @ (posedge clock)  
    if (clear) 	A <= 0; else if (incr) A <= A + 1;endmodule