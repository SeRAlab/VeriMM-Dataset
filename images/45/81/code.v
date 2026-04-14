module top_module(
    input [3:0] in,
    input [1:0] shift_amt,
    input dir,
    output reg [3:0] out
);always @(*) begin
        case (shift_amt)
            2'b00: out = in;
            2'b01: out = (dir == 1) ? {in[2:0], in[3]} : {in[1:0], in[3:2]};
            2'b10: out = (dir == 1) ? {in[1:0], in[3:2]} : {in[2:0], in[3]};
            2'b11: out = {in[0], in[3:1]};
        endcase
    end

endmodule