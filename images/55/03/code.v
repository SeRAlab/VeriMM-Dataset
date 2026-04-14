module johnson_counter (
        input clk,
        input reset,
        output reg [2:0] johnson);always @(posedge clk) begin
    if (reset)
        johnson <= 3'b000;
    else
        johnson <= {~johnson[0], johnson[2:1]};
end

endmodule