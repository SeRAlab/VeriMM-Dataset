module ethernet_mac_controller(  
    input clk,  
    input reset,  
    input frame_ready,  
    input frame_done,  
    output reg [1:0] state  
);  
    // State encoding  
    parameter IDLE = 2'd0, RECEIVE = 2'd1, PROCESS = 2'd2;  
      
    // State transition logic  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: begin  
                    if (frame_ready)  
                        state <= RECEIVE;  
                end  
                RECEIVE: begin  
                    if (frame_done)  
                        state <= PROCESS;  
                end  
                PROCESS: begin  
                    state <= IDLE;  
                end  
            endcase  
        end  
    end  
endmodule