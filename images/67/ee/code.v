module top_module(
    input [3:0] A,
    input [1:0] control,
    output reg [3:0] X
);always @* begin
    case (control)
        2'b00: X = A;
        2'b01: X = {A[0], A[3:1]};
        2'b10: X = {A[1:0], A[3:2]};
        2'b11: X = {A[2:0], A[3]};
    endcase
end

endmodule