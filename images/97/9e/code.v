module top_module(
    input a,
    input b,
    input sel_b1,
    output reg out_mux
);always @(*) begin
    if(sel_b1) begin
        out_mux = b;
    end else begin
        out_mux = a;
    end
end

endmodule