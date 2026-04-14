module top_module(
    input [7:0] addr,
    input [31:0] dataw,
    input memrw,
    output [31:0] datar,
    input clk
    );reg [31:0] mem [255:0];
		assign #100 datar = mem [addr];  
		always @ (posedge(clk))
				begin
					if (memrw == 1'b0)
						mem [addr] <= dataw;
				end
endmodule