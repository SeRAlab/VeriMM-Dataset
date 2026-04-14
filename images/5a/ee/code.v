module top_module(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] Q
);reg [7:0] shift_reg;
reg [15:0] add_reg;
integer i;  // Declare i as an integer

always @ (A or B) begin
    shift_reg = B;
    add_reg = 0;
    for (i = 0; i < 8; i = i + 1) begin
        if (A[i] == 1) begin
            add_reg = add_reg + (shift_reg << i);
        end
    end
    Q = add_reg;
end

endmodule