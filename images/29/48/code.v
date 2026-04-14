module nvme_command_decoder(  
    input wire clk,  
    input wire reset,  
    input wire [3:0] command,  
    output reg [1:0] cmd_type  
);  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        cmd_type <= 2'b11; // INVALID  
    end else begin  
        case (command)  
            4'b0000: cmd_type <= 2'b00; // READ  
            4'b0001: cmd_type <= 2'b01; // WRITE  
            4'b0010: cmd_type <= 2'b10; // FLUSH  
            default: cmd_type <= 2'b11; // INVALID  
        endcase  
    end  
end  
endmodule