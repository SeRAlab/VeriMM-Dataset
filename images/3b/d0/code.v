module wifi_module(  
    input [2:0] command,  
    output reg [4:0] message  
);  
    always @(*) begin  
        case (command)  
            3'b000: message = 5'b00001; // Connect  
            3'b001: message = 5'b00010; // Disconnect  
            3'b010: message = 5'b00100; // Send Data  
            3'b011: message = 5'b01000; // Receive Data  
            3'b100: message = 5'b10000; // Status  
            default: message = 5'b00000; // Invalid command  
        endcase  
    end  
endmodule