module siso_shift_register(  
    input Din,  
    input Clk,  
    input Reset,  
    output reg Dout  
);  
    reg [4:0] shift_reg; // 5-bit shift register  
  
    always @(posedge Clk or posedge Reset) begin  
        if (Reset) begin  
            shift_reg <= 5'b00000;  
            Dout <= 0;  
        end else begin  
            shift_reg <= {shift_reg[3:0], Din};  
            Dout <= shift_reg[4];  
        end  
    end  
endmodule