module pcie_fsm (  
    input clk,  
    input rst_n,  
    input req,  
    input ack,  
    output reg [1:0] state  
);  
    // State encoding  
    parameter IDLE = 2'b00,  
              REQUEST = 2'b01,  
              RESPONSE = 2'b10;  

    // Sequential logic for state transitions  
    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n)  
            state <= IDLE;  
        else begin  
            case (state)  
                IDLE: if (req) state <= REQUEST;  
                REQUEST: if (ack) state <= RESPONSE;  
                RESPONSE: if (!req) state <= IDLE;  
                default: state <= IDLE;  
            endcase  
        end  
    end  
endmodule