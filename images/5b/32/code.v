module top_module(
    sw,
    clk,
    led
);input [1:0] sw;
input clk;
output [3:0] led;
reg [3:0] led;




always @(posedge clk) begin: S0L0_LOGIC
    if ((sw[0] == 0)) begin
        led[0] <= 1'b1;
    end
    else begin
        led[0] <= 1'b0;
    end
end

endmodule