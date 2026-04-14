module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    input [1:0] select,
    input M,
    output reg [3:0] S,
    output reg V
);reg [3:0] selected_input;
reg [3:0] result;

// 4-input multiplexer
always @*
begin
    case (select)
        2'b00: selected_input = A;
        2'b01: selected_input = B;
        2'b10: selected_input = C;
        2'b11: selected_input = D;
    endcase
end

// 4-bit adder/subtractor with overflow detection
always @*
begin
    if (M == 1'b0) // addition
    begin
        result = selected_input + B;
        if ((result[3] == 1 && selected_input[3] == 0 && B[3] == 0) || (result[3] == 0 && selected_input[3] == 1 && B[3] == 1))
            V = 1'b1;
        else
            V = 1'b0;
    end
    else // subtraction
    begin
        result = selected_input - B;
        if ((result[3] == 0 && selected_input[3] == 1 && B[3] == 0) || (result[3] == 1 && selected_input[3] == 0 && B[3] == 1))
            V = 1'b1;
        else
            V = 1'b0;
    end
end

assign S = result;

endmodule