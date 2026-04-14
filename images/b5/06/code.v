module top_module(
    input D, RESET_B, CLK,
    output reg Q  // Change output to output reg
);always @(posedge CLK or negedge RESET_B) begin
    if (!RESET_B) begin
        Q <= 0;
    end else begin
        Q <= D;
    end
end

endmodule