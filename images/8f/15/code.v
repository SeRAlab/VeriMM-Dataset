module enable_register(
	input clk,
	input rst,
	input en,
	input [31:0] data_in,
	
	output reg [31:0] q
);
    always @(posedge clk) begin
        if (rst) begin
            q <= 32'b00000000000000000000000000000000;
        end else if (en) begin
            q <= data_in;
        end
    end
endmodule