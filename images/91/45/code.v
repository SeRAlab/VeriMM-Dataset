module top_module(
    input A, B, sel, reset, clk,
    output reg out
);always @(posedge clk, negedge reset) begin
    if(!reset) begin
        out <= 0;
    end else begin
        if(sel == 0) begin
            out <= A;
        end else begin
            out <= B;
        end
    end
end

endmodule