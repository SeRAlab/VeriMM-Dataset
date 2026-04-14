module mux4to1(
    input [15:0] d0,
    input [15:0] d1,
    input [15:0] d2,
    input [15:0] d3,
    input [1:0] sel,

    output reg [15:0] y
);

always@(*)
begin
    case(sel)
        2'b00: y = d0;   // select d0
        2'b01: y = d1;   // select d1
        2'b10: y = d2;   // select d2
        2'b11: y = d3;   // select d3
        default: y = 16'b0;  // default
    endcase
end

endmodule