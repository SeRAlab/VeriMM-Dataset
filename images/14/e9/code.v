module memory_allocator #(parameter NUM_BLOCKS = 4)  
(  
    input wire clk,  
    input wire reset,  
    input wire [1:0] request, // 00: free, 01: allocate, 10: check status  
    input wire [1:0] block_id, // block ID to allocate/free  
    output reg [NUM_BLOCKS-1:0] status // memory block status  
);  
    integer i;  
   
    initial begin  
        status = 0;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            status <= 0;  
        end else begin  
            case (request)  
                2'b01: // allocate  
                    if (status[block_id] == 0) begin  
                        status[block_id] <= 1;  
                    end  
                2'b00: // free  
                    status[block_id] <= 0;  
                default:;  
            endcase  
        end  
    end  
endmodule