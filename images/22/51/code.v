module rc_oscillator(
    input clk,
    input rst,
    output reg out
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            out <= 0;
        else
            out <= ~out;  // Toggle output
    end
endmodule