module phase_detector (  
    input clk_a,  
    input clk_b,  
    input reset,  
    output reg lead,  
    output reg lag,  
    output reg in_phase  
);  

    reg [1:0] state;  
    parameter S_INIT = 2'b00, S_LEAD = 2'b01, S_LAG = 2'b10, S_IN_PHASE = 2'b11;  

    always @(posedge clk_a or posedge reset) begin  
        if (reset) begin  
            state <= S_INIT;  
            lead <= 0;  
            lag <= 0;  
            in_phase <= 0;  
        end  
        else begin  
            case (state)  
                S_INIT: begin  
                    if (clk_b) state <= S_IN_PHASE;  
                end  
                S_IN_PHASE: begin  
                    if (clk_b) begin  
                        lead <= 0;  
                        lag <= 0;  
                        in_phase <= 1;  
                    end  
                    else begin  
                        state <= S_LEAD;  
                    end  
                end  
                S_LEAD: begin  
                    lead <= 1;  
                    lag <= 0;  
                    in_phase <= 0;  
                    if (~clk_b) state <= S_LAG;  
                end  
                S_LAG: begin  
                    lead <= 0;  
                    lag <= 1;  
                    in_phase <= 0;  
                    if (clk_b) state <= S_IN_PHASE;  
                end  
                default: state <= S_INIT;  
            endcase  
        end  
    end  
endmodule