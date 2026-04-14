module top_module(
     clk,
     reset
);input clk;
input reset;

reg [15 : 0] cnt;

always@(posedge clk or negedge reset) begin
    if(!reset) begin
        cnt <= 16'd0;
    end
    else begin
        cnt <= cnt + 16'd1;
    end
end

endmodule