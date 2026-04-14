module reset_controller(  
    input wire clk,  
    input wire reset_n,  
    output reg state  
);  
    // State definition  
    localparam STATE_IDLE = 1'b0;  
    localparam STATE_ACTIVE = 1'b1;  
  
    // Initial state  
    initial begin  
        state = STATE_IDLE;  
    end  
  
    // State transition logic  
    always @(posedge clk or negedge reset_n) begin  
        if (!reset_n) begin  
            state <= STATE_IDLE;  // Reset to idle state  
        end else begin  
            state <= STATE_ACTIVE; // Active state on clock edge  
        end  
    end  
endmodule