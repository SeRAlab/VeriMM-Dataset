module d_flipflop(D, clk, rst, Q);
    input D, clk, rst;
    output reg Q;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            Q <= 1'b0;
        end else begin
            Q <= D;
        end
    end
endmodule