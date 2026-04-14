module qam_encoder (  
    input [3:0] data,  
    output reg [1:0] I,  
    output reg [1:0] Q  
);  

always @(*) begin  
    case (data[1:0])  
        2'b00: begin I = 2'b00; Q = 2'b00; end  
        2'b01: begin I = 2'b00; Q = 2'b01; end  
        2'b10: begin I = 2'b01; Q = 2'b00; end  
        2'b11: begin I = 2'b01; Q = 2'b01; end  
        default: begin I = 2'b00; Q = 2'b00; end  
    endcase  
end  
endmodule