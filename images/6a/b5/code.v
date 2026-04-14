module top_module(
    input [3:0] in,
    input enable,
    output reg [3:0] out,
    output reg gs
    );always @(in or enable)
    begin
        if (enable)
        begin
            gs = 0;
            case (in)
                4'd0: out = 4'b0000;
                4'd1: out = 4'b0001;
                4'd2: out = 4'b0011;
                4'd3: out = 4'b0010;
                4'd4: out = 4'b0110;
                4'd5: out = 4'b0111;
                4'd6: out = 4'b0101;
                4'd7: out = 4'b0100;
                4'd8: out = 4'b1100;
                4'd9: out = 4'b1101;
                default: 
                begin
                    out = 4'b1111; gs = 1;
                end
            endcase
        end
        else
        begin
            out = 4'b1111; gs = 1;
        end
    end
endmodule