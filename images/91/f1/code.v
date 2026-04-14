module top_module(
    input [7:0] select,
    input [31:0] in,
    output reg [31:0] out0,
    output reg [31:0] out1,
    output reg [31:0] out2,
    output reg [31:0] out3,
    output reg [31:0] out4,
    output reg [31:0] out5,
    output reg [31:0] out6,
    output reg [31:0] out7
);always @(*) begin
    case (select)
        8'h00: begin out0 = in; out1 = 0; out2 = 0; out3 = 0; out4 = 0; out5 = 0; out6 = 0; out7 = 0; end
        8'h01: begin out0 = 0; out1 = in; out2 = 0; out3 = 0; out4 = 0; out5 = 0; out6 = 0; out7 = 0; end
        8'h02: begin out0 = 0; out1 = 0; out2 = in; out3 = 0; out4 = 0; out5 = 0; out6 = 0; out7 = 0; end
        8'h03: begin out0 = 0; out1 = 0; out2 = 0; out3 = in; out4 = 0; out5 = 0; out6 = 0; out7 = 0; end
        8'h04: begin out0 = 0; out1 = 0; out2 = 0; out3 = 0; out4 = in; out5 = 0; out6 = 0; out7 = 0; end
        8'h05: begin out0 = 0; out1 = 0; out2 = 0; out3 = 0; out4 = 0; out5 = in; out6 = 0; out7 = 0; end
        8'h06: begin out0 = 0; out1 = 0; out2 = 0; out3 = 0; out4 = 0; out5 = 0; out6 = in; out7 = 0; end
        8'h07: begin out0 = 0; out1 = 0; out2 = 0; out3 = 0; out4 = 0; out5 = 0; out6 = 0; out7 = in; end
        default: begin out0 = 0; out1 = 0; out2 = 0; out3 = 0; out4 = 0; out5 = 0; out6 = 0; out7 = 0; end
    endcase
end

endmodule