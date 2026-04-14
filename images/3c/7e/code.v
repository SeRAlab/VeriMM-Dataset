module phase_detector (  
    input clk,  
    input reset,  
    input A,  
    input B,  
    output reg [1:0] phase_out  
);  
    // State encoding  
    parameter IN_PHASE = 2'b00,  
              A_LEADS = 2'b01,  
              B_LEADS = 2'b10;  
  
    reg [1:0] state, next_state;  
  
    // State transition  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= IN_PHASE;  
        else  
            state <= next_state;  
    end  
  
    // Next state logic  
    always @(*) begin  
        case (state)  
            IN_PHASE: begin  
                if (A && !B)  
                    next_state = A_LEADS;  
                else if (!A && B)  
                    next_state = B_LEADS;  
                else  
                    next_state = IN_PHASE;  
            end  
            A_LEADS: begin  
                if (!A && B)  
                    next_state = IN_PHASE;  
                else if (!A && !B)  
                    next_state = A_LEADS;  
                else  
                    next_state = A_LEADS;  
            end  
            B_LEADS: begin  
                if (A && !B)  
                    next_state = IN_PHASE;  
                else if (A && B)  
                    next_state = B_LEADS;  
                else  
                    next_state = B_LEADS;  
            end  
            default: next_state = IN_PHASE;  
        endcase  
    end  
  
    // Output logic  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            phase_out <= 2'b00;  
        else begin  
            case (state)  
                IN_PHASE: phase_out <= 2'b00;  
                A_LEADS: phase_out <= 2'b01;  
                B_LEADS: phase_out <= 2'b10;  
                default: phase_out <= 2'b00;  
            endcase  
        end  
    end  
endmodule