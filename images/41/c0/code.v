module top_module(
    input      [1:0] sel,
    input      [7:0] in0,
    input      [7:0] in1,
    input      [7:0] in2,
    input      [7:0] in3,
    output reg [7:0] y
);always @(*) begin
    case (sel)
        2'd0: y = in0;
        2'd1: y = in1;
        2'd2: y = in2;
        2'd3: y = in3;
    endcase
end

endmodule