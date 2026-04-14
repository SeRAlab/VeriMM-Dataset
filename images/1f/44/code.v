module JK_flip_flop (  
    input J,  
    input K,  
    input clk,  
    input reset,  
    input preset,  
    output reg Q,  
    output reg Qn  
);  
    always @(posedge clk or posedge reset or posedge preset) begin  
        if (reset) begin  
            Q <= 0;  
            Qn <= 1;  
        end  
        else if (preset) begin  
            Q <= 1;  
            Qn <= 0;  
        end  
        else begin  
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
        end  
    end  
endmodule