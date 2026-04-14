module pcie_sm(  
    input clk,  
    input rst,  
    input start,  
    input ack,  
    input done,  
    output reg [1:0] current_state  
);  
    // State encoding  
    localparam IDLE = 2'b00,  
               REQUEST = 2'b01,  
               RESPONSE = 2'b10;  
               
    // State register  
    reg [1:0] next_state;  
      
    // Sequential logic for state transition  
    always @(posedge clk or posedge rst) begin  
        if (rst)  
            current_state <= IDLE;  
        else  
            current_state <= next_state;  
    end  
      
    // Combinational logic for next state  
    always @(*) begin  
        case (current_state)  
            IDLE: begin  
                if (start)  
                    next_state = REQUEST;  
                else  
                    next_state = IDLE;  
            end  
            REQUEST: begin  
                if (ack)  
                    next_state = RESPONSE;  
                else  
                    next_state = REQUEST;  
            end  
            RESPONSE: begin  
                if (done)  
                    next_state = IDLE;  
                else  
                    next_state = RESPONSE;  
            end  
            default: next_state = IDLE;  
        endcase  
    end  
endmodule