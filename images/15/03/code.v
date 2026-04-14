module chebyshev_filter(input [1:0] coeff,  
                        input x_in,  
                        output reg y_out);  
  
    always @(*) begin  
        case(coeff)  
            2'b00: y_out = x_in;  
            2'b01: y_out = (x_in & 1'b1) ^ (x_in & 1'b0);  
            2'b10: y_out = (x_in & 1'b1) ^ ((x_in & 1'b1) >> 1);  
            2'b11: y_out = (x_in & 1'b1) ^ (x_in & 1'b1);  
            default: y_out = 1'b0;  
        endcase  
    end  
endmodule