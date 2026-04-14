module top_module(
    input clk,
    input rst,
    input [9:0] data,
    output reg dout
);reg[3:0] i;
reg[3:0] i_next;
reg dout_reg;

always @(*) begin
	i_next = i + 1;
	if(i_next == 10) begin
		i_next = 0;
	end
end

always @(posedge clk) begin
    if(rst) begin
        i <= 4'd9;
    end else begin
        i <= i_next;
        dout <= data[i];
    end
end

endmodule