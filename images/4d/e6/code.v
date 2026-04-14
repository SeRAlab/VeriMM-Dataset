module johnson_counter_3bit(
    input clk,
    input rst_n,

    output reg [2:0] q
);

// Johnson Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q <= 3'b000;
    else
        q <= {q[1:0], ~q[2]};
end

endmodule