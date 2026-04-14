module top_module(
    sw,
    clk,
    led
);input [1:0] sw;
input clk;
output [3:0] led;
reg [3:0] led;




always @(posedge clk) begin: S2L4_LOGIC
    if ((sw[0] == 0)) begin
        led[2-1:0] <= 0;
    end
    else begin
        led[2-1:0] <= 3;
    end
    if ((sw[1] == 0)) begin
        led[4-1:2] <= 0;
    end
    else begin
        led[4-1:2] <= 3;
    end
end

endmodule