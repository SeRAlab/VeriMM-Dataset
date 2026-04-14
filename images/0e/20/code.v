module interrupt_controller(  
    input clk,  
    input reset,  
    input high_priority_req,  
    input low_priority_req,  
    output reg high_priority_serviced,  
    output reg low_priority_serviced  
);  

    reg [1:0] state;  
    parameter IDLE = 2'b00, HIGH_PRIORITY = 2'b01, LOW_PRIORITY = 2'b10;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
            high_priority_serviced <= 0;  
            low_priority_serviced <= 0;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (high_priority_req) begin  
                        state <= HIGH_PRIORITY;  
                    end else if (low_priority_req) begin  
                        state <= LOW_PRIORITY;  
                    end  
                end  
                HIGH_PRIORITY: begin  
                    high_priority_serviced <= 1;  
                    state <= IDLE;  
                end  
                LOW_PRIORITY: begin  
                    low_priority_serviced <= 1;  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule