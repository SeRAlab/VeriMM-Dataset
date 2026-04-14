module top_module(
    input clk,
    input rst,
    input load_i,
    input [31:0] Shift_Value_i,
    input [31:0] Shift_Data_i,
    input Left_Right_i,
    input Bit_Shift_i,
    output reg [31:0] N_mant_o
);always @(posedge clk) begin
    if (rst) begin
        N_mant_o <= 0;
    end else if (load_i) begin
        if (Bit_Shift_i) begin
            if (Left_Right_i) begin
                N_mant_o <= Shift_Data_i << Shift_Value_i;
            end else begin
                N_mant_o <= Shift_Data_i >> Shift_Value_i;
            end
        end else begin
            if (Left_Right_i) begin
                N_mant_o <= Shift_Data_i << (Shift_Value_i % 32);
            end else begin
                N_mant_o <= Shift_Data_i >> (Shift_Value_i % 32);
            end
        end
    end else begin
        N_mant_o <= N_mant_o;
    end
end

endmodule