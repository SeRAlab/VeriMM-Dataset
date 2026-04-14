module verified_mux_2to1(sel, in0, in1, out);

    input sel;
    input [7:0] in0;
    input [7:0] in1;
    output [7:0] out;
    reg [7:0] out;

    always @(*)
        begin
            out = sel ? in1 : in0;
        end

endmodule