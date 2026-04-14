module top_module(
        input [1:0] data,
        output reg q,
        output reg zero
    );always @(*)
    begin
        case(data)
            2'b00: begin
                q = 1'b0;
                zero = 1'b1;
            end
            2'b01: begin
                q = 1'b1;
                zero = 1'b0;
            end
            2'b10: begin
                q = 1'b0;
                zero = 1'b0;
            end
            2'b11: begin
                q = 1'b1;
                zero = 1'b0;
            end
        endcase
    end
endmodule