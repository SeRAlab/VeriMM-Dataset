module verified_mux_2to1(
    input sel,
    input in0,
    input in1,
    
    output reg out
);
    always @(*) begin
        if (sel)
            out = in1;
        else
            out = in0;
    end
endmodule