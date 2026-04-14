module top_module(clk, in, out);input clk;
input [3:0] in;
output [2:0] out;
reg [2:0] out;

always @(posedge clk) begin
    case (in)
        4'b0000, 4'b0001, 4'b0010, 4'b0011:
            out <= {in[2:0], 1'b0};
        4'b1000, 4'b1001, 4'b1010, 4'b1011:
            out <= {1'b0, in[3:1]};
        default:
            out <= 3'b0;
    endcase
end

endmodule