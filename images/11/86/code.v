module bluetooth_status_decoder(  
    input [2:0] status,  
    output reg [1:0] code  
);  

always @(*) begin  
    case(status)  
        3'b000: code = 2'b00; // Disconnected  
        3'b001: code = 2'b01; // Connected  
        3'b010: code = 2'b10; // Pairing  
        default: code = 2'b00; // Default to Disconnected  
    endcase  
end  
endmodule