module top_module(
    input clock, reset, start, Zero,
    output Ready, Load_regs, Add_dec
);parameter S_Idle = 1'b0, S_Mul = 1'b1;

reg state, next_state;

always @(posedge clock, posedge reset)
    if (reset)
        state <= S_Idle;
    else
        state <= next_state;

always @(*)
begin
    case (state)
        S_Idle: next_state = Load_regs ? S_Mul : S_Idle;
        S_Mul: next_state = Add_dec ? S_Idle : S_Mul;
        default: next_state = 1'bx;
    endcase
end

assign Ready = state == S_Idle;
assign Load_regs = Ready & start;
assign Add_dec = (state == S_Mul & ~Zero);

endmodule