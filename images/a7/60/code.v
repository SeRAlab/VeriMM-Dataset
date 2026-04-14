module parallel_load_register(
	input clk,
	input rst,
	input load,
	input [15:0] data_in,
	
	output reg [15:0] q
);
    always @(posedge clk) begin
        if (rst) begin
            q <= 16'b0000000000000000;
        end else if (load) begin
            q <= data_in;
        end
    end
endmodule