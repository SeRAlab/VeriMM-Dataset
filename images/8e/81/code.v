module top_module(
    input CLK,
    input D,
    input RESET_B,
    output reg Q,   // Changed to output reg
    output reg Q_N  // Changed to output reg
);always @(posedge CLK) begin
        if(RESET_B == 0) begin
            Q <= 0;
            Q_N <= 1;
        end
        else begin
            Q <= D;
            Q_N <= ~D;
        end
    end

endmodule