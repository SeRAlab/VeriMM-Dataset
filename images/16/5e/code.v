module state_machine(  
    input clk,  
    input reset,  
    input start,  
    input done,  
    output reg [1:0] state  
);  
    parameter IDLE = 2'b00, WORK = 2'b01, DONE = 2'b10;  
   
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: if (start) state <= WORK;  
                WORK: if (done) state <= DONE;  
                DONE: state <= DONE;  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule