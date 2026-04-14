module pcie_request_handler(  
    input wire clk,  
    input wire reset,  
    input wire request,  
    input wire request_type,  // 0 for read, 1 for write  
    output reg ack  
);  
    always @(*) begin  
        if (reset) begin  
            ack = 0;  
        end else if (request && (request_type == 0 || request_type == 1)) begin  
            ack = 1;  
        end else begin  
            ack = 0;  
        end  
    end  
endmodule