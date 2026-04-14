module ShiftRegister (
	input clk,
	input rst_n,
	input serial_in,
	output reg [7:0] parallel_out
);
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            parallel_out <= 8'b0;
        end else begin
            parallel_out <= {parallel_out[6:0], serial_in};
        end
    end
endmodule