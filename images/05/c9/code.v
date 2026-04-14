module pcie_interface(  
    input  [4:0] address,  
    input  [2:0] command,  
    output reg [2:0] status  
);  
    always @(*) begin  
        case (command)  
            3'b000: status = 3'b000; // invalid command  
            3'b001: status = 3'b001; // read command  
            3'b010: status = 3'b010; // write command  
            default: status = 3'b000; // default case for other commands  
        endcase  
    end  
endmodule