module d_flip_flop(
    input clk,
    input reset,
    input d,
    output reg q
    );

    always @(posedge clk or posedge reset) begin
        if (reset)
            q <= 0; // Reset output to 0
        else
            q <= d; // Capture input value
    end
endmodule