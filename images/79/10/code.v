module top_module(
    count,
    enable,
    clk,
    reset
);output [11:0] count;
reg [11:0] count;
input enable;
input clk;
input reset;




always @(posedge clk, negedge reset) begin: COUNTER_COUNTER
    if (reset == 0) begin
        count <= 0;
    end
    else begin
        if (enable) begin
            count <= (count + 1);
        end
    end
end

endmodule