module up_counter(clk, reset, Q);
    input clk, reset;
    output reg [2:0] Q;

    always @(posedge clk) begin
        if (reset)
            Q <= 3'b000;
        else
            Q <= Q + 1;
    end
endmodule