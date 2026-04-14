module counter(
    input clk,
    input reset,
    input enable,
    input up,
    output reg [7:0] count);always @(posedge clk, posedge reset) begin
    if (reset)
        count <= 0;
    else if (enable) begin
        if (up)
            count <= count + 1;
        else
            count <= count - 1;
    end
end
endmodule