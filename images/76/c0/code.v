module top_module(
    input [3:0] A,
    input [3:0] B,
    input SUB,
    output reg [3:0] result,
    output reg OVFL
    );always @(*) begin
        if(SUB == 1) begin
            result = A - B;
            OVFL = (result[3] == 1) ? 1 : 0;
        end
        else begin
            result = A + B;
            OVFL = (result[3] == 1) ? 1 : 0;
        end
    end

endmodule