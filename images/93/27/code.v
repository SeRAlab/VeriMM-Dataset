module top_module(
    input [3:0] A,
    input [1:0] S,
    input D,
    output reg [3:0] B  // Change output to reg
);reg [3:0] shift_reg;

    always @(*) begin
        case(S)
            2'b00: shift_reg = A;
            2'b01: shift_reg = {A[2:0], A[3]};
            2'b10: shift_reg = {A[1:0], A[3:2]};
            2'b11: shift_reg = {A[0], A[3:1]};
        endcase

        if(D == 1) begin
            B = shift_reg >> S;  // Update B within an always block
        end else begin
            B = shift_reg << S;  // Update B within an always block
        end
    end

endmodule