module top_module(
    input [1:0] data,
    output reg q,
    output zero
);always @(*) begin
        case (data)
            2'b00: q = 1'b0; // no input active
            2'b01: q = 1'b1; // data[0] active
            2'b10: q = 1'b1; // data[1] active
            2'b11: q = 1'b1; // both inputs active, priority on data[1]
            default: q = 1'b0;
        endcase
    end

    assign zero = (data == 2'b00);

endmodule