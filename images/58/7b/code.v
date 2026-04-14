module DFF (
	input clk,
	input rst_n,
	input set,
	input d,
	output reg q
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            q <= 0;
        end else if (set) begin
            q <= 1;
        end else begin
            q <= d;
        end
    end
endmodule