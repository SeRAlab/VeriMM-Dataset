module nvme_controller (  
    input [4:0] command,  
    output reg [4:0] status  
);  
    always @(*) begin  
        case (command)  
            5'b00000: status = 5'b11111; // SUCCESS  
            5'b00001: status = 5'b11110; // ERROR  
            5'b00010: status = 5'b11101; // TIMEOUT  
            default: status = 5'b00000;   // UNKNOWN  
        endcase  
    end  
endmodule