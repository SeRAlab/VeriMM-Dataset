module top_module(
    input [3:0] A, B, C, D,
    input reset,
    output [1:0] out,
    output valid
);reg [1:0] out_reg;
    reg valid_reg;
    
    always @(*) begin
        if (reset) begin
            out_reg <= 2'b00;
            valid_reg <= 1'b0;
        end
        else if (A && !valid_reg) begin
            out_reg <= 2'b00;
            valid_reg <= 1'b1;
        end
        else if (B && !valid_reg) begin
            out_reg <= 2'b01;
            valid_reg <= 1'b1;
        end
        else if (C && !valid_reg) begin
            out_reg <= 2'b10;
            valid_reg <= 1'b1;
        end
        else if (D && !valid_reg) begin
            out_reg <= 2'b11;
            valid_reg <= 1'b1;
        end
    end
    
    assign out = out_reg;
    assign valid = valid_reg;
    
endmodule