module NVMe_Command_Decoder(  
    input [4:0] command,  
    output reg [2:0] command_type  
);  
    always @(*) begin  
        case (command)  
            5'b00000: command_type = 3'b000; // NOP  
            5'b00001: command_type = 3'b001; // READ  
            5'b00010: command_type = 3'b010; // WRITE  
            5'b00011: command_type = 3'b011; // FLUSH  
            5'b00100: command_type = 3'b100; // FORMAT  
            default: command_type = 3'b111;   // Unknown Command  
        endcase  
    end  
endmodule