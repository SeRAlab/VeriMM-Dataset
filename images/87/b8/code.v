module top_module(
    input [1:0] SEL,
    input EN,
    output reg [15:0] Q
);reg [3:0] temp_Q1, temp_Q2;

always @(SEL, EN) begin
    if (EN == 1'b0) begin
        Q <= 16'b0;
    end
    else begin
        case (SEL)
            2'b00: temp_Q1 = 4'b0001;
            2'b01: temp_Q1 = 4'b0010;
            2'b10: temp_Q1 = 4'b0100;
            2'b11: temp_Q1 = 4'b1000;
        endcase
        
        case (temp_Q1)
            4'b0001: temp_Q2 = 16'b0000000000000001;
            4'b0010: temp_Q2 = 16'b0000000000000010;
            4'b0100: temp_Q2 = 16'b0000000000000100;
            4'b1000: temp_Q2 = 16'b0000000000001000;
        endcase
        
        Q <= temp_Q2;
    end
end

endmodule