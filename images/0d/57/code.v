module priority_encoder_4to2(  
    input wire I3,  
    input wire I2,  
    input wire I1,  
    input wire I0,  
    output reg [1:0] Y,  
    output reg V  
);  
  
always @(*) begin  
    if (I3) begin  
        Y = 2'b11;  
        V = 1;  
    end else if (I2) begin  
        Y = 2'b10;  
        V = 1;  
    end else if (I1) begin  
        Y = 2'b01;  
        V = 1;  
    end else if (I0) begin  
        Y = 2'b00;  
        V = 1;  
    end else begin  
        Y = 2'b00;  
        V = 0;  
    end  
end  
endmodule