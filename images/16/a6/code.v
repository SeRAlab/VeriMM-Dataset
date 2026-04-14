module state_machine(  
    input clk,  
    input reset,  
    input [1:0] inp,  
    output reg [1:0] state  
);  
    // State definition  
    parameter S0 = 2'b00,  
              S1 = 2'b01,  
              S2 = 2'b10,  
              S3 = 2'b11;  

    // Sequential logic for state transition  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            state <= S0;  
        else begin  
            case (state)  
                S0: state <= (inp == 2'b11) ? S0 : S1;  
                S1: state <= S2;  
                S2: state <= S3;  
                S3: state <= (inp == 2'b11) ? S0 : S0;  
                default: state <= S0;  
            endcase  
        end  
    end  
endmodule