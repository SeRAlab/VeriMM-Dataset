module sata_controller (  
    input clk,  
    input reset,  
    input start,  
    input suspend,  
    input resume,  
    output reg [1:0] state  
);  
    // State encoding  
    localparam IDLE = 2'b00,  
               ACTIVE = 2'b01,  
               SUSPEND = 2'b10;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: if (start) state <= ACTIVE;  
                ACTIVE: if (suspend) state <= SUSPEND;  
                SUSPEND: if (resume) state <= ACTIVE;  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule