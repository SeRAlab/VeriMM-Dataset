module top_module(
    input [3:0] in_value,
    output reg [3:0] out_value   // Change output to reg type
);always @(*) begin
        case (in_value)
            4'd0: out_value = 4'b0000;
            4'd1: out_value = 4'b0001;
            4'd2: out_value = 4'b0010;
            4'd3: out_value = 4'b0011;
            4'd4: out_value = 4'b0100;
            4'd5: out_value = 4'b0101;
            4'd6: out_value = 4'b0110;
            4'd7: out_value = 4'b0111;
            4'd8: out_value = 4'b1000;
            4'd9: out_value = 4'b1001;
            default: out_value = 4'bXXXX;
        endcase
    end
endmodule