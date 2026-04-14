module memory_allocator (  
    input clk,  
    input reset,  
    input [1:0] request, // 00: free, 01: allocate, 10: status check  
    output reg allocated // 0: free, 1: allocated  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            allocated <= 0;  
        end else begin  
            case (request)  
                2'b00: allocated <= 0; // free memory  
                2'b01: allocated <= 1; // allocate memory  
                2'b10: allocated <= allocated; // check status, no change  
                default: allocated <= allocated;  
            endcase  
        end  
    end  
endmodule