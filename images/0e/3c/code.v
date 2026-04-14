module JKFlipFlop (  
    input J,  
    input K,  
    input Clock,  
    input Reset,  
    output reg Q,  
    output reg Qn  
);  
    always @(posedge Clock or posedge Reset) begin  
        if (Reset) begin  
            Q <= 0;  
            Qn <= 1;  
        end else begin  
            case ({J, K})  
                2'b00: begin  
                    Q <= Q;  
                end  
                2'b01: begin  
                    Q <= 0;  
                end  
                2'b10: begin  
                    Q <= 1;  
                end  
                2'b11: begin  
                    Q <= ~Q;  
                end  
            endcase  
            Qn <= ~Q;  
        end  
    end  
endmodule