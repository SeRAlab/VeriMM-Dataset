module branch_predictor (  
    input [1:0] state,  
    input taken,  
    output reg [1:0] next_state  
);  

always @(*) begin  
    case ({state, taken})  
        3'b000: next_state = 2'b00;  
        3'b001: next_state = 2'b01;  
        3'b010: next_state = 2'b00;  
        3'b011: next_state = 2'b10;  
        3'b100: next_state = 2'b01;  
        3'b101: next_state = 2'b11;  
        3'b110: next_state = 2'b10;  
        3'b111: next_state = 2'b11;  
        default: next_state = state;  
    endcase  
end  
endmodule