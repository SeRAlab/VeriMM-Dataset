module johnson_counter3 (
    input clk,
    output reg [2:0] q
);

    always_ff @(posedge clk) begin
        q <= {q[1:0], ~q[2]};
    end

endmodule