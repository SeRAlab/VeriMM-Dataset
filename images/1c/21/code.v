module JK_FF (  
    input wire J,  
    input wire K,  
    input wire CLK,  
    input wire RST,  
    output reg Q,  
    output reg Qn  
);  
    always @(posedge CLK or posedge RST) begin  
        if (RST) begin  
            Q <= 0;  
            Qn <= 1;  
        end else begin  
            case ({J, K})  
                2'b00: ; // No change  
                2'b01: begin  
                    Q <= 0;  
                    Qn <= 1;  
                end  
                2'b10: begin  
                    Q <= 1;  
                    Qn <= 0;  
                end  
                2'b11: begin  
                    Q <= ~Q;  
                    Qn <= ~Qn;  
                end  
            endcase  
        end  
    end  
endmodule