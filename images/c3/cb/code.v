module mux4to1 (
    input in0,
    input in1,
    input in2,
    input in3,
    input sel0,
    input sel1,
    input clk,
    output reg out
);
    
    always @(posedge clk) begin
        if (sel1 == 0 && sel0 == 0) begin
            out <= in0;
        end else if (sel1 == 0 && sel0 == 1) begin
            out <= in1;
        end else if (sel1 == 1 && sel0 == 0) begin
            out <= in2;
        end else begin
            out <= in3;
        end
    end
    
endmodule