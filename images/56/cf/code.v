module mux2to1(    
    input in0,
    input in1,
    input sel,
    output reg out
);

always @(*) begin
    if (sel == 1'b0)
        out = in0;
    else
        out = in1;
end

endmodule