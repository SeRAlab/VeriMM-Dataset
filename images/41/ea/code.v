module top_module(
    input wire [2:0] sel,
    output reg [1:0] bin
    );always @ (*) begin
        case (sel)
            3'b000 : bin = 2'b00;
            3'b001 : bin = 2'b01;
            3'b010 : bin = 2'b10;
            3'b011 : bin = 2'b11;
            default : bin = 2'b00;
        endcase
    end
endmodule