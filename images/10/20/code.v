module BoothMultiplier(
    input signed [3:0] A,
    input signed [3:0] B,
    output reg signed [7:0] Product
);
    reg [3:0] A_reg, B_reg;
    reg [7:0] P;
    integer i;

    always @(*) begin
        A_reg = A;
        B_reg = B;
        P = 0;
        
        for (i = 0; i < 4; i = i + 1) begin
            case({B_reg[0], B_reg[1]})
                2'b01: P = P + (A_reg << i); // Add A shifted
                2'b10: P = P - (A_reg << i); // Subtract A shifted
                default: ;
            endcase
            B_reg = {B_reg[3], B_reg[3:1]}; // Arithmetic right shift
        end
        
        Product = P;
    end
endmodule