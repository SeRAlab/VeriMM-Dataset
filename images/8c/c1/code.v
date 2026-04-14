module mux_2to1(
    input en,
    input sel,
    input [7:0] in0,
    input [7:0] in1,
    output reg [7:0] out
);
    always @(*) begin
        if (en) begin
            if (sel) begin
                out = in1;
            end else begin
                out = in0;
            end
        end else begin
            out = 8'b00000000;
        end
    end
endmodule