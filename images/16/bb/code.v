module SR_FlipFlop (  
    input wire S,  
    input wire R,  
    input wire PRE,  
    input wire CLR,  
    input wire clk,  
    output reg Q,  
    output reg Qn  
);  
    always @(posedge clk or posedge PRE or posedge CLR) begin  
        if (PRE) begin  
            Q <= 1;  
            Qn <= 0;  
        end else if (CLR) begin  
            Q <= 0;  
            Qn <= 1;  
        end else begin  
            case ({S, R})  
                2'b00: begin  
                    Q <= Q;  
                    Qn <= Qn;  
                end  
                2'b01: begin  
                    Q <= 0;  
                    Qn <= 1;  
                end  
                2'b10: begin  
                    Q <= 1;  
                    Qn <= 0;  
                end  
                2'b11: begin  
                    // Invalid state, keep previous state  
                    Q <= Q;  
                    Qn <= Qn;  
                end  
            endcase  
        end  
    end  
endmodule