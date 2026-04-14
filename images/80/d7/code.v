module top_module(input clk, input D, input S, input CE, output reg Q);always @(posedge clk) begin
        if (CE == 1'b1) begin
            if (S == 1'b1) begin
                Q <= 1'b1;
            end else begin
                Q <= D;
            end
        end
    end
endmodule