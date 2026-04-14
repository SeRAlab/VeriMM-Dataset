module sata_controller(  
    input clk,  
    input reset,  
    input start,  
    input error,  
    output reg [1:0] state  
);  
    // State encoding  
    localparam IDLE = 2'b00;  
    localparam ACTIVE = 2'b01;  
    localparam ERROR = 2'b10;  

    // State transition logic  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: if (start) state <= ACTIVE;  
                ACTIVE: if (error) state <= ERROR; else state <= IDLE;  
                ERROR: if (reset) state <= IDLE;  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule