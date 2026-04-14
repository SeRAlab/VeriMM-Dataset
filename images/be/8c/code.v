module top_module(
    input CLK,
    input SET,
    input RESET,
    input [3:0] D,
    output reg [3:0] Q
);always @(posedge CLK) begin
        if (SET && !RESET) begin
            Q <= 4'b1111;
        end else if (RESET && !SET) begin
            Q <= 4'b0000;
        end else begin
            Q <= D;
        end
    end

endmodule