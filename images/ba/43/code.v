module top_module(input clk, input [5:0] din, output [5:0] dout);reg [5:0] queue [0:3];
        integer i;

        always @(posedge clk) begin
                queue[0] <= din;
                for (i = 1; i < 4; i=i+1) begin
                        queue[i] <= queue[i-1];
                end
        end

	assign dout = queue[3];
endmodule