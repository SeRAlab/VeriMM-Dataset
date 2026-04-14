module bluetooth_module(  
    input [4:0] command,  
    output reg [4:0] status  
);  
    always @(*) begin  
        case (command)  
            5'b00000: status = 5'b00001; // Command 0 -> Status 1  
            5'b00001: status = 5'b00010; // Command 1 -> Status 2  
            5'b00010: status = 5'b00011; // Command 2 -> Status 3  
            5'b00011: status = 5'b00100; // Command 3 -> Status 4  
            default:  status = 5'b00000; // Any other command -> Status 0  
        endcase  
    end  
endmodule