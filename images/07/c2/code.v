module convolutional_encoder (  
    input clk,  
    input reset,  
    input din,  
    output reg [1:0] dout  
);  
  
    reg [1:0] shift_reg;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            shift_reg <= 2'b00;  
            dout <= 2'b00;  
        end else begin  
            dout <= {din ^ shift_reg[1], din ^ shift_reg[0]};  
            shift_reg <= {din, shift_reg[1]};  
        end  
    end  
endmodule