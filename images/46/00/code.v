module top_module(
    input is_jz,
    input is_jnz,
    input is_jl,
    input is_jg,
    input is_jump,
    input is_zero,
    input is_sign,
    output reg should_jump
    );always @(is_jz or is_jnz or is_jl or is_jg or is_jump or is_zero or is_sign)
	begin
		should_jump <= ((is_zero & is_jz) | (~is_zero & is_jnz) | (is_sign & is_jl) |
		(~is_sign & is_jg) | is_jump);
	end

endmodule