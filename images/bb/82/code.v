module top_module(clk, reset, count);input clk, reset;
output [3:0] count;

reg [3:0] count;

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        count <= 4'd0;
    end else begin
        count <= count + 4'd1;
    end
end

endmodule