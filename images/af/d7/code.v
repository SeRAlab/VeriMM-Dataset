module top_module(
    input [3:0] inputs,
    input [1:0] select,
    output reg out
);always @(*) begin
    case (select)
        2'b00: out = inputs[0];
        2'b01: out = inputs[1];
        2'b10: out = inputs[2];
        2'b11: out = inputs[3];
    endcase
end

endmodule