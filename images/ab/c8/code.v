module top_module(
    input in_0,
    input in_1,
    input sel,
    output reg out
);always @(*) begin
        if(sel == 0) begin
            out = in_0;
        end
        else begin
            out = in_1;
        end
    end

endmodule