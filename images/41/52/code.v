module top_module(
  input				CLK		,
  input 			RST		,
  input 			start	,
  input  	 [63:0] C		,
  output reg [63:0] Cminus1
);reg [63:0] mem_buffer;

always @(posedge CLK)
begin
	if (RST)
		begin
			Cminus1 <= 64'h0;
			mem_buffer <= 64'h0;
		end
	else
		if (start) 
			begin
				mem_buffer <= C;
				Cminus1 <= mem_buffer;
			end
end

endmodule