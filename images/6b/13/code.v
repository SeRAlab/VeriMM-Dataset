module jk_ff(
    input clk,
    input reset,
    input J,
    input K,
    output reg Q
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 0;
        end else if (J & K) begin
            Q <= ~Q;
        end else if (J & ~K) begin
            Q <= 1;
        end else if (~J & K) begin
            Q <= 0;
        end
    end

endmodule