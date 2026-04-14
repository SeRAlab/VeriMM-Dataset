module johnson_counter_6bit(
    input clk,
    input reset,
    output reg [5:0] count
);

always @(posedge clk) begin
    if (reset)
        count <= 6'b000000;
    else
        count <= {~count[5], count[5:1]};
end

endmodule