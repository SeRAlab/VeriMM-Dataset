module top_module(
     input      CLK,
     input      D,
     output reg Q
     );always @ (posedge CLK) begin 
	    Q <= #1 D; 
    end
endmodule