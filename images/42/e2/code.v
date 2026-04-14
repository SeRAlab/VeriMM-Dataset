module ring_counter(
    input clk,
    input reset,
    output reg [11:0] count);

always @(posedge clk) begin
    if (reset)
        count <= 12'b000000000001;
    else
        count <= {count[10:0], count[11]};
end
endmodule