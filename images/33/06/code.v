module mux2to1_hazard (
    input [3:0] data0,
    input [3:0] data1,
    input sel,
    output reg [3:0] out
);
    always @(*) begin
        case (sel)
            1'b0: out = data0;
            1'b1: out = data1;
            default: out = 4'bxxxx; // undefined state
        endcase
    end
endmodule