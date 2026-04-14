module top_module(
    input [3:0] data_in,
    input [1:0] ctrl,
    output reg [1:0] data_out
    );always @(*) begin
        case(ctrl)
            2'b00: data_out = data_in << 2;
            2'b01: data_out = data_in & 2'b11;
            2'b10: data_out = ~data_in;
            2'b11: data_out = data_in | 2'b11;
        endcase
    end

endmodule