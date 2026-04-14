module d_flip_flop (
    input clk,
    input d,
    output reg q,
    output reg q_bar
);

    always @ (posedge clk) begin
        q <= d;
        q_bar <= ~d;
    end

endmodule