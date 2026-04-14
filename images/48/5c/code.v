module mux_4to1_4bit(
    input [3:0] d0, d1, d2, d3, 
    input [1:0] sel, 
    output reg [3:0] y);

    always @(*) begin
        case(sel)
            2'b00: y = d0;
            2'b01: y = d1;
            2'b10: y = d2;
            2'b11: y = d3;
            default: y = 4'b0000;
        endcase
    end
endmodule