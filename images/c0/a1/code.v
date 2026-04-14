module Register #(parameter WIDTH = 32, INIT = 0)(
    input  clock,
    input  reset,
    input  enable,
    input  [(WIDTH-1):0] D,
    output reg [(WIDTH-1):0] Q
    );
    initial
        Q = INIT;
    always @(posedge clock) begin
        Q <= (reset) ? INIT : ((enable) ? D : Q);
    end
endmodule