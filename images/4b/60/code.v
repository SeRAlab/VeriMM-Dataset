module top_module(
    clk_en,
    clock,
    dataa,
    datab,
    overflow,
    result
);input clk_en;
    input clock;
    input [31:0] dataa;
    input [31:0] datab;
    output reg overflow;
    output reg [31:0] result;

    wire signa = dataa[31];
    wire signb = datab[31];
    wire [7:0] expa = dataa[30:23];
    wire [7:0] expb = datab[30:23];
    wire [22:0] fraca = (signa) ? -dataa[22:0] : dataa[22:0];
    wire [22:0] fracb = (signb) ? -datab[22:0] : datab[22:0];
    wire signed [7:0] expo_diff = expa - expb;
    wire [23:0] fracb_shifted = (expo_diff > 0) ? {1'b1, fracb} >> expo_diff : {1'b1, fracb};
    wire [23:0] fraca_shifted = (expo_diff < 0) ? {1'b1, fraca} >> -expo_diff : {1'b1, fraca};
    
    reg [23:0] result_frac;
    reg [7:0] result_exp;
    reg result_sign;

    always @ (posedge clock) begin
        if (clk_en) begin
            if (expa > expb) begin
                result_frac = fraca_shifted - fracb_shifted;
                result_sign = signa; // Determine sign based on operation
            end else begin
                result_frac = fracb_shifted - fraca_shifted;
                result_sign = signb; // Determine sign based on operation
            end
        
            // Normalization and exponent assignment
            result_exp = (result_frac[23] == 1) ? expa + 1 : expa; // Example normalization condition
            overflow = (result_exp == 8'hFF) ? 1'b1 : 1'b0; // Overflow detection
            result = {result_sign, result_exp, result_frac[22:0]}; // Combine to form final result
        end else begin
            result_frac = 0;
            result_exp = 0;
            result_sign = 0;
            overflow = 0;
            result = 0;
        end
    end

endmodule