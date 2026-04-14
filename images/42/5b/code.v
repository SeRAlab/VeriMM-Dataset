module top_module(
    input [31:0] A,
    input [31:0] B,
    input [31:0] C,
    input [31:0] D,
    input [4:0] shift_amount,
    input SEL0,
    input SEL1,
    output reg [31:0] Y
);reg [31:0] selected_input;

always @(*) begin
    case ({SEL1, SEL0})
        2'b00: selected_input = A;
        2'b01: selected_input = B;
        2'b10: selected_input = C;
        2'b11: selected_input = D;
    endcase
    
    if (shift_amount > 0) begin
        Y = selected_input << shift_amount;
    end else begin
        Y = selected_input >> -shift_amount;
    end
end

endmodule