module top_module(
    input wire in,
    output reg out0,
    output reg out1,
    output reg out2,
    output reg out3,
    output reg out
);always @(*) begin
    case(in)
        0: begin
            out0 = 0;
            out1 = 0;
            out2 = 0;
            out3 = 0;
            out = 0;
        end
        1: begin
            out0 = 1;
            out1 = 0;
            out2 = 0;
            out3 = 0;
            out = 1;
        end
        2: begin
            out0 = 0;
            out1 = 1;
            out2 = 0;
            out3 = 0;
            out = 1;
        end
        3: begin
            out0 = 1;
            out1 = 1;
            out2 = 0;
            out3 = 0;
            out = 1;
        end
        4: begin
            out0 = 0;
            out1 = 0;
            out2 = 1;
            out3 = 0;
            out = 1;
        end
        5: begin
            out0 = 1;
            out1 = 0;
            out2 = 1;
            out3 = 0;
            out = 1;
        end
        6: begin
            out0 = 0;
            out1 = 1;
            out2 = 1;
            out3 = 0;
            out = 1;
        end
        7: begin
            out0 = 1;
            out1 = 1;
            out2 = 1;
            out3 = 0;
            out = 1;
        end
        8: begin
            out0 = 0;
            out1 = 0;
            out2 = 0;
            out3 = 1;
            out = 1;
        end
        default: begin
            out0 = 0;
            out1 = 0;
            out2 = 0;
            out3 = 0;
            out = 0;
        end
    endcase
end

endmodule