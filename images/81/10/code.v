module top_module(
    input wire [1:0] Shift_Amt,
    input wire [31:0] Reg_B_info,
    input wire [15:0] Imediato,
    input wire [31:0] MEM_out,
    output reg [4:0] Shift_Amt_out
);always @(*) begin
        case (Shift_Amt)
            2'b00:
                Shift_Amt_out <= Reg_B_info[4:0];
            2'b01:
                Shift_Amt_out <= Imediato[10:6];
            2'b10:
                Shift_Amt_out <= MEM_out[4:0];
        endcase
end    
endmodule