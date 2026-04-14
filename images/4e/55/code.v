module top_module(
    input [3:0] data_in,
    input [1:0] sel,
    output reg out
);always @(*) begin
        case (sel)
            2'b00: out <= data_in[0];
            2'b01: out <= data_in[1];
            2'b10: out <= data_in[2];
            2'b11: out <= data_in[3];
        endcase
    end

endmodule