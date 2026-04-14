module mux2to1_enable (
    input [3:0] in0,
    input [3:0] in1,
    input sel,
    input en,
    output reg [3:0] out
);always @(*) begin
    if (en) begin
        if (sel) begin
            out = in1;
        end else begin
            out = in0;
        end
    end else begin
        out = 4'b0;
    end
end

endmodule