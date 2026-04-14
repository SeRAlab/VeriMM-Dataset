module top_module(
    input D,
    input CLK,
    input SET,
    input RESET,
    output reg Q,    // Changed to output reg
    output reg Q_N   // Changed to output reg
);always @(posedge CLK) begin
        if (SET) begin
            Q <= 1;
            Q_N <= 0;
        end else if (RESET) begin
            Q <= 0;
            Q_N <= 1;
        end else begin
            Q <= D;
            Q_N <= ~D;
        end
    end
    
endmodule