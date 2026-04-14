module Register8bit (
	input clk,
	input reset,
	input enable,
	input [7:0] d,
	output reg [7:0] q
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 8'b00000000;
        else if (enable)
            q <= d;
    end
endmodule