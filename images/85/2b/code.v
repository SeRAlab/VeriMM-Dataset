module JohnsonCounter (
	input clk,
	input rst_n,
	output reg [2:0] counter_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter_out <= 3'b000;
        end else begin
            counter_out <= {~counter_out[2], counter_out[2:1]};
        end
    end
endmodule