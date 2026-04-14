module top_module(
	input clk,
    input signed [17:0] slicer_in, ref_level,
    output reg [1:0] slicer_out
);always @ (posedge clk)
    if (slicer_in >= ref_level)	
        slicer_out <= 2'b11;
    else if (slicer_in > 18'sd0)	
        slicer_out <= 2'b10;
    else if (slicer_in > -ref_level)	
        slicer_out <= 2'b01;
    else
        slicer_out <= 2'b00;	

endmodule