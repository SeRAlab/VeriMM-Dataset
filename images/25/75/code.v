module nvme_controller(clk, rst, start, operation, state);  
    input clk;  
    input rst;  
    input start;  
    input operation;  
    output reg [1:0] state;  

    parameter IDLE = 2'b00, READ = 2'b01, WRITE = 2'b10;  

    always @(posedge clk or posedge rst) begin  
        if (rst)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: if (start)  
                          state <= (operation) ? WRITE : READ;  
                READ: state <= IDLE;  
                WRITE: state <= IDLE;  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule