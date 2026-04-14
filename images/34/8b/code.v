module phase_detector(clk_a, clk_b, phase_out, reset);  
    input clk_a;  
    input clk_b;  
    input reset;  
    output reg phase_out;  

    reg [1:0] state;  
    reg [1:0] next_state;  

    // State Encoding  
    parameter IDLE = 2'b00;  
    parameter LEADING = 2'b01;  
    parameter LAGGING = 2'b10;  

    always @(posedge clk_a or posedge reset) begin  
        if (reset)  
            state <= IDLE;  
        else  
            state <= next_state;  
    end  

    always @(posedge clk_a) begin  
        case (state)  
            IDLE: begin  
                if (clk_b)  
                    next_state = LEADING;  
                else  
                    next_state = IDLE;  
            end  
            LEADING: begin  
                if (!clk_b)  
                    next_state = LAGGING;  
                else  
                    next_state = LEADING;  
            end  
            LAGGING: begin  
                if (clk_b)  
                    next_state = LEADING;  
                else  
                    next_state = LAGGING;  
            end  
            default: next_state = IDLE;  
        endcase  
    end  

    always @(posedge clk_a) begin  
        case (state)  
            LEADING: phase_out <= 1;  
            LAGGING: phase_out <= 0;  
            default: phase_out <= 0;  
        endcase  
    end  
endmodule