module top_module(
    input D, 
    input Clk, 
    input reset,
    output reg Q  // Change to output reg
);always @(posedge Clk) begin
    if (reset) begin
        Q <= 0;
    end else begin
        Q <= D;
    end
end

endmodule