module top_module(
    input CLK,
    input D,
    input S,
    input R,
    output reg Q
);always @(posedge CLK or posedge S or posedge R) begin
        if (R) begin
            Q <= 1'b0; // Reset output
        end else if (S) begin
            Q <= 1'b1; // Set output
        end else begin
            Q <= D; // latch D input
        end
    end

endmodule