module johnson_counter(
    input clk,
    input reset,
    output reg [7:0] count);always @(posedge clk) begin
    if (reset)
        count <= 8'b00000000;
    else
        count <= {~count[7], count[7:1]};
end
endmodule