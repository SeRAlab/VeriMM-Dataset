module slam_fsm (  
    input wire clk,  
    input wire rst,  
    input wire start,  
    input wire mapping_done,  
    input wire complete,  
    output reg [1:0] state_out  
);  
    // State encoding  
    parameter IDLE = 2'b00;  
    parameter LOCALIZE = 2'b01;  
    parameter MAPPING = 2'b10;  
    parameter COMPLETE = 2'b11;  
    
    reg [1:0] state;  
    
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: if (start) state <= LOCALIZE;  
                LOCALIZE: if (mapping_done) state <= MAPPING;  
                MAPPING: if (complete) state <= COMPLETE;  
                COMPLETE: state <= IDLE;  // Reset to IDLE after COMPLETE  
                default: state <= IDLE;  
            endcase  
        end  
    end  
    
    always @(*) begin  
        state_out = state;  
    end  
endmodule