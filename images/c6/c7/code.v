module add_4bit_sat (
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] Y
);
    
    always @ (A or B) begin
        Y = A + B;
        if(Y > 4'b1111) begin
            Y = 4'b1111;
        end
    end
    
endmodule