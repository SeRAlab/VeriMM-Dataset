module d_flip_flop(D, clk, reset, Q);
    input D;
    input clk;
    input reset;
    output Q;
    reg Q;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 1'b0;
        end
        else begin
            Q <= D;
        end
    end
endmodule