module top_module(
    input [7:0] data_in,
    input [2:0] sel,
    output reg out
);always @(*) begin
        case(sel)
            3'b000: out = data_in[0];
            3'b001: out = data_in[1];
            3'b010: out = data_in[2];
            3'b011: out = data_in[3];
            3'b100: out = data_in[4];
            3'b101: out = data_in[5];
            3'b110: out = data_in[6];
            3'b111: out = data_in[7];
            default: out = 1'b0;
        endcase
    end

endmodule