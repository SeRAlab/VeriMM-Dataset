module johnson_counter(
    input clk,
    input reset,
    output reg [2:0] count);always @(posedge clk) begin
    if (reset) begin
        count <= 3'b000;
    end
    else begin
        count <= {~count[2], count[2:1]};
    end
end
endmodule