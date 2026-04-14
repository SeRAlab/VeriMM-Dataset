module top_module(
    input clk, reset,
    output reg [3:0] led
);always @(posedge clk) begin
        if(reset) begin
            led <= 4'b0000;
        end else begin
            led <= led + 1;
        end
    end

endmodule