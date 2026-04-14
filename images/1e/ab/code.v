module divide_by_8_fsm (  
    input clk,  
    input reset,  
    output reg out  
);  

    reg [2:0] state;  
    reg [2:0] next_state;  

    // State encoding  
    parameter S0 = 3'b000;  
    parameter S1 = 3'b001;  
    parameter S2 = 3'b010;  
    parameter S3 = 3'b011;  
    parameter S4 = 3'b100;  
    parameter S5 = 3'b101;  
    parameter S6 = 3'b110;  
    parameter S7 = 3'b111;  

    // State transition logic  
    always @ (posedge clk or posedge reset) begin  
        if (reset)  
            state <= S0;  
        else  
            state <= next_state;  
    end  

    // Next state logic  
    always @ (state) begin  
        case (state)  
            S0: begin  
                next_state = S1;  
                out = 0;  
            end  
            S1: begin  
                next_state = S2;  
                out = 0;  
            end  
            S2: begin  
                next_state = S3;  
                out = 0;  
            end  
            S3: begin  
                next_state = S4;  
                out = 0;  
            end  
            S4: begin  
                next_state = S5;  
                out = 0;  
            end  
            S5: begin  
                next_state = S6;  
                out = 0;  
            end  
            S6: begin  
                next_state = S7;  
                out = 0;  
            end  
            S7: begin  
                next_state = S0;  
                out = 1;  // Output high when reaching state S7 (multiple of 8)  
            end  
            default: begin  
                next_state = S0;  
                out = 0;  
            end  
        endcase  
    end  

endmodule