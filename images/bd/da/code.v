module top_module(
    clk,
    reset,
    A,
    B,
    C,
    out
);input clk, reset, A, B, C;
    output reg out;

    always @(posedge clk, negedge reset) begin
        if(!reset) begin
            out <= 1'b0;
        end else if(B && C) begin
            out <= A;
        end else begin
            out <= B;
        end
    end

endmodule