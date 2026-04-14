module top_module(
    input [3:0] in,
    output reg [1:0] pos  );always@(*) begin
        case(in)
            4'b1000:pos=2'd3;
            4'b0100,4'b1100:pos=2'd2;
            4'b0010,4'b0110,4'b1010,4'b1110:pos=2'd1;
            default:pos=2'd0;
        endcase
    end
endmodule