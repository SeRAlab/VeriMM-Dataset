module johnson_counter_3bit(
    input clk,
    input reset,
    output reg [2:0] count
);

always @(posedge clk) begin
    if (reset)
        count <= 3'b000;
    else
        count <= {~count[2], count[2:1]};
end

endmodule