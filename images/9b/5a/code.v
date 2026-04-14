module shift_register(D, clk, reset, load, shift, Q);
    input [7:0] D;
    input clk, reset, load, shift;
    output reg [7:0] Q;

    always @(posedge clk or posedge reset) begin
        if (reset)
            Q <= 8'b0;
        else if (load)
            Q <= D;
        else if (shift)
            Q <= {Q[6:0], 1'b0};
    end
endmodule