module mux_2_1_en(
    input in0,
    input in1,
    input en,
    output reg out
);

always @(*) begin
    out = en ? in1 : in0;
end

endmodule