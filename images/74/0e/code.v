module top_module(
    input [3:0] A,
    input [3:0] B,
    input SUB,
    input CIN,
    output reg [3:0] sum,
    output reg overflow
);reg [3:0] temp_sum;
    reg temp_overflow;
    
    always @(*) begin
        if (SUB) begin
            temp_sum = A - B - (~CIN);
            temp_overflow = (A < B + (~CIN));
        end else begin
            temp_sum = A + B + CIN;
            temp_overflow = (temp_sum < A) && (temp_sum < B);
        end
    end
    
    assign sum = temp_sum;
    assign overflow = temp_overflow;
    
endmodule