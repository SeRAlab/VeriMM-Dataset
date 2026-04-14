module mux_4to1(
    input  [1:0] sel,
    input  [7:0] d0,
    input  [7:0] d1,
    input  [7:0] d2,
    input  [7:0] d3,
    output reg [7:0] y
);

always @(*) begin
    case (sel)
        2'd0: y = d0;
        2'd1: y = d1;
        2'd2: y = d2;
        2'd3: y = d3;
        default: y = 8'd0;
    endcase
end

endmodule