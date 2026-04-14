module d_flip_flop (
    input clk,
    input d,
    output reg q,
    output q_bar
);

    always @(posedge clk) begin
        q <= d;
    end

    assign q_bar = ~q;

endmodule