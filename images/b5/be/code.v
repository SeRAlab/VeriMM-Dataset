module top_module(
    input [3:0] A,
    input [3:0] B,
    input SUB,
    output reg [3:0] Y
);always @(*) begin
        if(SUB == 0) begin // Addition
            Y = A + B;
        end else begin // Subtraction
            Y = A - B;
        end
    end

endmodule