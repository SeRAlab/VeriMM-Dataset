module qam_modulator(  
    input [3:0] data,  
    output reg [1:0] out_I,  
    output reg [1:0] out_Q  
);  
    always @(*) begin  
        case (data[3:2])  
            2'b00: out_I = 2'b00;  
            2'b01: out_I = 2'b01;  
            2'b10: out_I = 2'b10;  
            2'b11: out_I = 2'b11;  
            default: out_I = 2'b00;  
        endcase  
        
        case (data[1:0])  
            2'b00: out_Q = 2'b00;  
            2'b01: out_Q = 2'b01;  
            2'b10: out_Q = 2'b10;  
            2'b11: out_Q = 2'b11;  
            default: out_Q = 2'b00;  
        endcase  
    end  
endmodule