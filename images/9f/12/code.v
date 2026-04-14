module d_flip_flop (
    input d,
    input clk,
    input rst,
    output reg q
);

    // Flip-flop logic
    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 1'b0;
        else
            q <= d;
    end

endmodule