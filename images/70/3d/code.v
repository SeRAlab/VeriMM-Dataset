module top_module(
    input A,
    input B,
    input C,
    input D,
    output reg [1:0] Y,
    output reg V
);always @ (A or B or C or D) begin
        if (A) begin
            Y = 2'b00;
            V = 1'b1;
        end else if (B) begin
            Y = 2'b01;
            V = 1'b1;
        end else if (C) begin
            Y = 2'b10;
            V = 1'b1;
        end else if (D) begin
            Y = 2'b11;
            V = 1'b1;
        end else begin
            Y = 2'b00;
            V = 1'b0;
        end
    end

endmodule