module bluetooth_module(  
    input [3:0] command,  
    output reg [2:0] status  
);  
    always @(*) begin  
        case (command)  
            4'b0000: status = 3'b000; // No Command  
            4'b0001: status = 3'b001; // Connect  
            4'b0010: status = 3'b010; // Disconnect  
            4'b0011: status = 3'b011; // Send Data  
            4'b0100: status = 3'b100; // Receive Data  
            default: status = 3'b000; // Default case  
        endcase  
    end  
endmodule