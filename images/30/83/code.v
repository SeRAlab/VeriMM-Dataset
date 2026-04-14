module pcie_request_decoder(  
    input [3:0] request_type,  
    output reg [1:0] command  
);  
    always @(*) begin  
        case(request_type)  
            4'b0000: command = 2'b00;  
            4'b0001: command = 2'b01;  
            4'b0010: command = 2'b10;  
            4'b0011: command = 2'b11;  
            default: command = 2'b00;  
        endcase  
    end  
endmodule