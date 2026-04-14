module top_module(input CLK, input D, output reg Q);always @(negedge CLK) begin
    Q <= ~D; // Invert the D input on the negative edge of the CLK
end

endmodule